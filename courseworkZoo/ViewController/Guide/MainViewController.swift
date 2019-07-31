//
//  MainViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 26/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import ReactiveSwift
import SwiftyGif


/**
 This class represents the main screen with a large map with markers of localities and animals with given coordinates. This class also ensures saying information about localities and animals when the user is at a locality or an animal with given coordinates.
 */
class MainViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    /// The view model which ensures getting data for the screen
    private var mainViewModel: MainViewModel
    /// The delegate which ensures taking user to different screens
    weak var flowDelegate: MainDelegate?
    /// The boolean representing whether the shortest path will be counted or not (only actualized)
    private var countShortestPath: Bool = true
    /// The location manager which ensures listening to changes of the actual location
    let locationManager = CLLocationManager()
    /// The scroll view for scrolling the main screen with map and information about any enough close animal
    private let scrollView: UIScrollView = UIScrollView()
    /// The view inside the scroll view with map and information about any enough close animal
    private let contentView: UIView = UIView()
    /// The vertical menu with buttons for actions (mostly going to a different screen, one item is for turning off (turning on) the voice)
    private var verticalMenu: UIVerticalMenu!
    /// The horizontal menu next to the second item of the vertical menu with buttons for actions (going to a different screen)
    private var horizontalMenu: UIView = UIView()
    /// The animation view with a speaking character.
    private var speakingCharacterImageView = try? UIImageView(gifImage: UIImage(gifName: "speakingCharacter.gif"), loopCount: 1000000000)
    /// The map of the zoo.
    private weak var zooPlanMapView: MKMapView!
    /// The multiline label for reading the actually machine-read text about a close locality or a close animal.
    private var textForReadingLabel: UILabel!
    
    
    /**
     - Parameters:
        - viewModel: instance of the view model for getting data for the screen implemented by this view controller
     */
    init(mainViewModel: MainViewModel){
        self.mainViewModel = mainViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.mainViewModel = MainViewModel(dependencies: AppDependency.shared)
        super.init()
        self.setupBindingsWithViewModelActions()
    }
    
    
    /**
     This function ensures binding this view controller with actions of the view model for getting localities and animals with known coordinates and actions ensuring machine-reading of information about a close animal or a close locality (it is given by maximum distance).
    */
    override func setupBindingsWithViewModelActions(){
        // adding annotations of localities (especially pavilions) with known coordinates to the map
        self.mainViewModel.getLocalitiesAction.values.producer.startWithValues {(localitiesList) in
            for locality in localitiesList{
                // making and adding an annotation of the actual locality to the map
                let annotation: MKPointAnnotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: locality.latitude, longitude: locality.longitude)
                annotation.coordinate = coordinate
                annotation.title = locality.title
                self.zooPlanMapView.addAnnotation(annotation)
            }
        }
        
        // registration of the action which ensures adding annotations of animals with known coordinates to the map after getting the list of animals with given coordinates
        self.mainViewModel.getAnimalsAction.values.producer.startWithValues { (animalList) in
            for animal in animalList{
                // making and adding an annotation of the actual animal to the map
                let coordinate = CLLocationCoordinate2D(latitude: animal.latitude, longitude: animal.longitude)
                let annotation: AnimalAnnotation = AnimalAnnotation(coordinate: coordinate, animal: animal)
                self.zooPlanMapView.addAnnotation(annotation)
            }
        }
        
        
        // registration of the actions for saying information about localities and animals in the closeness of the actual location
        self.mainViewModel.animalInClosenessAction.values.producer.startWithValues{ (animal) in
            self.mainViewModel.setCallbacksOfSpeechService(startCallback: {
                self.speakingCharacterImageView?.startAnimatingGif()
                self.textForReadingLabel.text = self.mainViewModel.textForShowingAbout(animal: animal)
            }, finishCallback: {
                self.speakingCharacterImageView?.stopAnimatingGif()
                self.textForReadingLabel.text = ""
            })
            self.mainViewModel.sayInformationAbout(animal: animal)
        }
        
        self.mainViewModel.localityInClosenessAction.values.producer.startWithValues{ locality in
            self.mainViewModel.setCallbacksOfSpeechService(startCallback: {
                self.speakingCharacterImageView?.startAnimatingGif()
                self.textForReadingLabel.text = self.mainViewModel.textForShowingAbout(locality: locality)
            }, finishCallback: {
                self.speakingCharacterImageView?.stopAnimatingGif()
                self.textForReadingLabel.text = ""
            })
            self.mainViewModel.sayInformationAbout(locality: locality)
        }
        
        
        // action for turning on or off the voice
        self.mainViewModel.isVoiceOnAction.values.producer.startWithValues{ voiceOn in
            if (voiceOn){
                self.verticalMenu.getItemAt(index: 4)?.changeActionString(actionString: "turnOffVoice")
            } else {
                self.verticalMenu.getItemAt(index: 4)?.changeActionString(actionString: "turnOnVoice")
            }
        }
        
        self.mainViewModel.getPlacemarksForTheActualPath.values.producer.startWithValues { placemarks in
            self.zooPlanMapView.removeOverlays(self.zooPlanMapView.overlays)
            self.mainViewModel.set(sourceLocation: self.zooPlanMapView.userLocation.coordinate)
            var lastPlacemark = placemarks[0]
            for placemark in placemarks[1...] {
                self.drawShortestRouteBetweenTwoPlacemarks(sourcePlacemark: lastPlacemark, destinationPlacemark: placemark)
                lastPlacemark = placemark
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.zooPlanMapView.removeAnnotations(self.zooPlanMapView.annotations)
        self.mainViewModel.getAnimalsAction.apply().start()
        self.mainViewModel.getLocalitiesAction.apply().start()
        
        self.mainViewModel.set(sourceLocation: self.zooPlanMapView.userLocation.coordinate)
        self.mainViewModel.getAnimalsInPath.values.producer.startWithValues {
             animalsInPath in
            self.mainViewModel.set(animalsInPath: animalsInPath)
        }
        self.mainViewModel.getAnimalsInPath.apply().start()
        self.mainViewModel.getPlacemarksForTheActualPath.apply(true).start()
    }
    
    /**
     This function ensures setting the location manager to watch the location with the best possibel accuracy. This function also ensures adding the map view and the navigation bar to the screen.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScrollView()
        self.view.backgroundColor = Colors.screenBodyBackgroundColor.color
        
        // adding a vertical menu
        let verticalMenu = UIVerticalMenu(width: 70, topOffset: 0, parentView: self.contentView)
        
        let goToLexiconItem = UIVerticalMenuItem(actionString: "goToLexicon", usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        goToLexiconItem.addTarget(self, action: #selector(goToLexiconItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(goToLexiconItem, height: 120, last: false)
        
        let selectAnimalsToPathItem = UIVerticalMenuItem(actionString: "selectAnimalsToPath", usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
        selectAnimalsToPathItem.addTarget(self, action: #selector(selectAnimalsToPathItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(selectAnimalsToPathItem, height: 90, last: false)
        
        let settingParametersOfVisitItem = UIVerticalMenuItem(actionString: "settingParametersOfVisit", usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
        settingParametersOfVisitItem.addTarget(self, action: #selector(settingParametersOfVisitItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(settingParametersOfVisitItem, height: 90, last: false)
        
        let selectInformationItem = UIVerticalMenuItem(actionString: "selectInformation", usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
        selectInformationItem.addTarget(self, action: #selector(selectInformationItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(selectInformationItem, height: 90, last: false)
        
        let turnOnOrOffVoiceItem = UIVerticalMenuItem(actionString: "turnOffVoice", usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
        turnOnOrOffVoiceItem.addTarget(self, action: #selector(turnOnOrOffVoiceItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(turnOnOrOffVoiceItem, height: 90, last: false)
        
        let helpItem = UIVerticalMenuItem(actionString: "help", usedBackgroundColor: Colors.helpButtonBackgroundColor.color)
        verticalMenu.addItem(helpItem, height: 90, last: true)
        self.verticalMenu = verticalMenu
        
        // adding a view for the title on the screen
        let titleHeader = UITitleHeader(title: "guideTitle", menuInTheParentView: verticalMenu, parentView: self.contentView)
        
        // adding the horizontal menu
        let horizontalMenu = UIView()
        horizontalMenu.backgroundColor = .black
        self.contentView.addSubview(horizontalMenu)
        horizontalMenu.snp.makeConstraints{ (make) in
            make.top.equalTo(goToLexiconItem.snp.bottom)
            make.left.equalTo(goToLexiconItem.snp.right)
            make.height.equalTo(90)
            make.width.equalToSuperview().offset(-198).multipliedBy(73.0 / 76.0)
        }
        self.horizontalMenu = horizontalMenu
        
        // add an item for saving path
        let savePathButton = self.getItemInTheHorizontalMenu(previousItem: selectAnimalsToPathItem, actionString: "savePath")
        savePathButton.addTarget(self, action: #selector(savePathButtonTapped(_:)), for: .touchUpInside)
        // add in item for choosing the path
        let chooseSavedPathButton = self.getItemInTheHorizontalMenu(previousItem: savePathButton, actionString: "chooseSavedPath")
        chooseSavedPathButton.addTarget(self, action: #selector(chooseSavedPathButtonTapped(_:)), for: .touchUpInside)
        
        
        let backgroundOfAnimationView = UIView()
        backgroundOfAnimationView.backgroundColor = Colors.titleBackgroundColor.color
        self.contentView.addSubview(backgroundOfAnimationView)
        backgroundOfAnimationView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.horizontalMenu.snp.top)
            make.left.equalTo(self.horizontalMenu.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(180)
        }
        
        if(self.speakingCharacterImageView == nil){
            print("Speaking character can't be loaded.")
        } else {
            backgroundOfAnimationView.addSubview(self.speakingCharacterImageView!)
            self.speakingCharacterImageView!.snp.makeConstraints{ (make) in
                make.left.equalTo(self.horizontalMenu.snp.right)
                make.top.equalTo(self.horizontalMenu.snp.top)
                make.width.equalTo(128)
                make.height.equalTo(180)
            }
            self.speakingCharacterImageView?.stopAnimatingGif()
        }
        
        // Views for showing statistics of the visit of the ZOO
        let viewForTheLengthOfThePath = UIView()
        viewForTheLengthOfThePath.backgroundColor = Colors.titleBackgroundColor.color
        self.contentView.addSubview(viewForTheLengthOfThePath)
        viewForTheLengthOfThePath.snp.makeConstraints { (make) in
            make.top.equalTo(self.horizontalMenu.snp.bottom)
            make.left.equalTo(verticalMenu.snp.right)
            make.width.equalTo(self.horizontalMenu.snp.width)
            make.height.equalTo(45)
        }
        let viewForTheLengthOfThePathLabel = UILabel()
        viewForTheLengthOfThePathLabel.attributedText = self.getAttributedStringWithStatistic(statistic: "lengthOfThePathInZOO", value: 0, units: "km")
        viewForTheLengthOfThePath.addSubview(viewForTheLengthOfThePathLabel)
        viewForTheLengthOfThePathLabel.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
        }
        
        let viewForTimeOfTheVisitOfTheZOO = UIView()
        viewForTimeOfTheVisitOfTheZOO.backgroundColor = Colors.titleBackgroundColor.color
        self.contentView.addSubview(viewForTimeOfTheVisitOfTheZOO)
        viewForTimeOfTheVisitOfTheZOO.snp.makeConstraints{ (make) in
            make.top.equalTo(viewForTheLengthOfThePath.snp.bottom)
            make.left.equalTo(verticalMenu.snp.right)
            make.width.equalTo(self.horizontalMenu.snp.width)
            make.height.equalTo(45)
        }
        let viewForTimeOfTheVisitOfTheZOOLabel = UILabel()
        viewForTimeOfTheVisitOfTheZOOLabel.attributedText = self.getAttributedStringWithStatistic(statistic: "timeOfTheVisitOfTheZOO", value: 0, units: "min")
        viewForTimeOfTheVisitOfTheZOO.addSubview(viewForTimeOfTheVisitOfTheZOOLabel)
        viewForTimeOfTheVisitOfTheZOOLabel.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
        }
        
        
        //adding the main map view
        let zooPlanMapView = MKMapView()
        self.contentView.addSubview(zooPlanMapView)
        zooPlanMapView.showsUserLocation = true
        zooPlanMapView.delegate = self
        zooPlanMapView.snp.makeConstraints { (make) in
            make.left.equalTo(verticalMenu.snp.right)
            make.right.equalToSuperview()
            make.top.equalTo(settingParametersOfVisitItem.snp.bottom)
            make.bottom.equalTo(verticalMenu.snp.bottom)
        }
        // setting of the ZOO plan map view for further work
        self.zooPlanMapView = zooPlanMapView
        
        self.textForReadingLabel = UILabel()
        self.textForReadingLabel.text = ""
        self.textForReadingLabel.numberOfLines = 0
        self.textForReadingLabel.lineBreakMode = .byWordWrapping
        self.textForReadingLabel.preferredMaxLayoutWidth = self.view.bounds.size.width * 11.0 / 12.0
        self.textForReadingLabel.sizeToFit()
        self.contentView.addSubview(self.textForReadingLabel)
        self.textForReadingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.zooPlanMapView.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
        
        // settings of the location manager
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        // adding loaded localities to map
        self.addLoadedLocalitiesToMap()
    }
    
    /**
     This function ensures setting up the scroll view for elements with informaiton about the animal. This function sets up the scroll view and the content view which is added to the scroll view.
     */
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // adding scroll view to main view and content view to the scroll view
        view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        //adding constraints to scroll view
        scrollView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        //adding constraints to content view
        contentView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /**
     This function ensures adding and then returning an item in the horizontal menu. It adds a button with a label and an image to the horizontal menu and then it returns the created menu item.
     - Parameters:
        - previousItem: The item in the menu next to the item which will be added and then returned
        - actionString: The string representing the given action of the item
     - Returns: The item of the menu as a button with a label and an image representing the given action
    */
    func getItemInTheHorizontalMenu(previousItem: UIButton, actionString: String) -> UIButton{
        let actionButton = UIButton()
        actionButton.backgroundColor = Colors.nonSelectedItemBackgroundColor.color
        actionButton.layer.cornerRadius = 1
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.black.cgColor
        self.horizontalMenu.addSubview(actionButton)
        actionButton.snp.makeConstraints{ (make) in
            make.left.equalTo(previousItem.snp.right)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview()
        }
        
        // add a text label to the action button
        let actionButtonLabel = UILabel()
        actionButtonLabel.textColor = .black
        actionButtonLabel.text = NSLocalizedString(actionString, comment: "")
        actionButtonLabel.textAlignment = .center
        actionButtonLabel.font = actionButtonLabel.font.withSize(9)
        actionButtonLabel.numberOfLines = 0
        actionButtonLabel.lineBreakMode = .byWordWrapping
        actionButtonLabel.preferredMaxLayoutWidth = actionButton.bounds.size.width - 4.0
        actionButtonLabel.sizeToFit()
        actionButton.addSubview(actionButtonLabel)
        actionButtonLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        }
        
        // add an icon of book to the action button
        let actionButtonIcon = UIImageView()
        actionButtonIcon.image = UIImage(named: actionString)
        actionButtonIcon.contentMode = .scaleToFill
        actionButton.addSubview(actionButtonIcon)
        actionButtonIcon.snp.makeConstraints{ (make) in
            make.top.equalTo(actionButtonLabel.snp.bottom).offset(2)
            make.width.equalTo(43)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        return actionButton
    }
    
    
    /**
     This function returns an attributed string with a statistic of the visit of the ZOO.
     - Returns: Attributed strings containing a statistic of the visit of the ZOO with the given value and the given unit.
    */
    func getAttributedStringWithStatistic(statistic: String, value: Float, units: String) -> NSAttributedString{
        let normalText = NSLocalizedString(statistic, comment: "") + " "
        let attributesOfNormalText = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9)]
        let attributedString = NSMutableAttributedString(string: normalText, attributes: attributesOfNormalText)
        
        let boldTextWithValueAndUnit = String(value) + " " + units
        let attributesOfBoldText = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 9)]
        let boldAttributedString = NSMutableAttributedString(string: boldTextWithValueAndUnit, attributes: attributesOfBoldText)
        attributedString.append(boldAttributedString)
        
        return attributedString
    }
    
    
    /**
        This function ensures adding markers of localities and animals with coordintates to the map of the ZOO by running of registered actions for getting the list of localities and animals with known coordinates.
     */
    func addLoadedLocalitiesToMap(){
        //running actions - getting localities and animals from the view model
        self.mainViewModel.getLocalitiesAction.apply().start()
        self.mainViewModel.getAnimalsAction.apply().start()
    }
    
    
    private func drawShortestRouteBetweenTwoPlacemarks(sourcePlacemark: MKPlacemark, destinationPlacemark: MKPlacemark){
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .walking
        
        // calculating the shortest path to the target selected location
        let directions = MKDirections(request: directionRequest)
        directions.calculate{ (response, error) in
            guard let directionResponse = response else {
                return
            }
            let routes = directionResponse.routes
            
            // finding the shortest route from the array of routes
            var shortestRoute = routes[0]
            for route in routes{
                if(route.distance < shortestRoute.distance){
                    shortestRoute = route
                }
            }
            
            self.zooPlanMapView.addOverlay(shortestRoute.polyline, level: .aboveRoads)
        }
    }
    
    /**
     This function is called each time when location was updated. In this function there are updated informations about location in the view model. There are also run actions for saying information about an animal or a locality which is close to the actual position
     
     - Parameters:
        - manager: The location manager
        - locations: The array of locations in which can be the actual location
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            self.mainViewModel.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.mainViewModel.localityInClosenessAction.apply().start()
            self.mainViewModel.animalInClosenessAction.apply().start()
            self.mainViewModel.getPlacemarksForTheActualPath.apply(false).start()
        }
    }
    
    
    /**
     This function ensures drawing the path from the actual locality to the selected target locality.
     
     - Parameters:
        - mapView: The MapView on which the shortest path should be drawed.
        - overlay: The value representing how the polyline will be rendered on the map (the polyline could be drawed for example above roads)
     
     - Returns: An object which ensures drawing the polyline representing the shortest path to the selected locality.
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        if var animalAnnotation = annotation as? AnimalAnnotation {
            let animal = animalAnnotation.animal
            var isTheAnimalInPath = false
            self.mainViewModel.getAnimalsInPath.values.producer.startWithValues{ (animalsInPath) in
                for animalInPath in animalsInPath {
                    if (animal.id == animalInPath.id) {
                        isTheAnimalInPath = true
                        break
                    }
                }
            }
            self.mainViewModel.getAnimalsInPath.apply().start()
            
            let imageName = isTheAnimalInPath ? "animalSelected" : "animal"
            
            animalAnnotation.isSelected = isTheAnimalInPath
            animalAnnotation.title = animalAnnotation.animal.title
            let annotationView = MKAnnotationView(annotation: animalAnnotation, reuseIdentifier: "animalAnnotation")
            annotationView.image = UIImage(named: imageName)
            annotationView.canShowCallout = true
            return annotationView
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "localityAnnotation")
        annotationView.image = UIImage(named: "animal")
        annotationView.canShowCallout = true
        return annotationView
    
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if var animalAnnotation = view.annotation as? AnimalAnnotation {
            self.mainViewModel.addOrRemoveAnimal(animal: animalAnnotation.animal)
            animalAnnotation.isSelected = !animalAnnotation.isSelected
            let imageName = animalAnnotation.isSelected ? "animalSelected" : "animal"
            view.image = UIImage(named: imageName)
            
            self.mainViewModel.getAnimalsInPath.values.producer.startWithValues { (animalsInPath) in
                self.mainViewModel.set(animalsInPath: animalsInPath)
            }
            self.mainViewModel.getAnimalsInPath.apply().start()
            self.mainViewModel.getPlacemarksForTheActualPath.apply(true).start()
        }
    }
    
    
    
    
    // MARK - Actions
    
    
    /**
     This function ensures going to the main screen of the lexicon part of the application after tapping the goToLexiconItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
    */
    @objc func goToLexiconItemTapped(_ sender: UIVerticalMenuItem){
        flowDelegate?.goToLexicon(in: self)
    }
    
    
    /**
     This function ensures going to the screen for selecting animal to the actual unsaved path after tapping the selectAnimalsToPathItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func selectAnimalsToPathItemTapped(_ sender: UIVerticalMenuItem){
        flowDelegate?.goToSelectAnimalsToPath(in: self)
    }
    
    
    /**
     This function ensures turning off the voice (or turning on if the voice is turned off) the turnOnOrOffVoiceItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func turnOnOrOffVoiceItemTapped(_ sender: UIVerticalMenuItem){
        self.mainViewModel.turnVoiceOnOrOff()
        self.mainViewModel.isVoiceOnAction.apply().start()
    }
    
    
    /**
     This function ensures going to the screen for setting parameters of the actual visit of the ZOO (walk speed and time spent at one animal during the visit of the ZOO) after tapping the settingParametersOfVIsitItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func settingParametersOfVisitItemTapped(_ sender: UIVerticalMenuItem){
        flowDelegate?.goToSettingParametersOfVisit(in: self)
    }
    
    
    /**
     This function ensures going to the screen for selecting information about an enough close animal which are machine-read after tapping the selectInformaitonItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func selectInformationItemTapped(_ sender: UIVerticalMenuItem){
        flowDelegate?.goToSelectInformation(in: self)
    }
    
    
    /**
     This function ensures going to the screen for choosing one of saved paths with animals after the tapping the chooseSavedPathButton button from the horizontal menu.
     - Parameters:
        - sender: The button with this method as a target which was tapped.
     */
    @objc func chooseSavedPathButtonTapped(_ sender: UIVerticalMenuItem){
        flowDelegate?.goToChooseSavedPath(in: self)
    }
    
    
    /**
     This function ensures showing a popover for saving the actual unsaved path with a title after the tapping the savePathButton button from the horizontal menu. This function shows the popover with a text field for filling the title and two buttons - one for saving the actual path and the second one for cancelling and closing the popover.
     - Parameters:
        - sender: The button with this method as a target which was tapped.
     */
    @objc func savePathButtonTapped(_ sender: UIVerticalMenu){
        let savePathVM = SavePathViewModel(dependencies: AppDependency.shared)
        let savePathPopoverVC = SavePathPopoverViewController(savePathViewModel: savePathVM)
        self.addChild(savePathPopoverVC)
        savePathPopoverVC.view.frame = self.view.frame
        self.view.addSubview(savePathPopoverVC.view)
        savePathPopoverVC.didMove(toParent: self)
    }

}