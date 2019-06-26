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


/**
 This class represents the main screen with a large map with markers of localities and animals with given coordinates. This class also ensures saying information about localities and animals when the user is at a locality or an animal with given coordinates.
 */
class MainViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    /// The view model which ensures getting data for the screen
    private var viewModel: MainViewModel
    /// The delegate which ensures taking user to different screens
    weak var flowDelegate: MainDelegate?
    /// The map of the zoo
    private weak var zooPlanMapView: MKMapView!
    /// The location manager which ensures listening to changes of the actual location
    let locationManager = CLLocationManager()
    
    /**
     - Parameters:
        - viewModel: instance of the view model for getting data for the screen implemented by this view controller
     */
    init(viewModel: MainViewModel){
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = MainViewModel(dependencies: AppDependency.shared)
        super.init()
    }
    
    /**
     This function ensures setting the location manager to watch the location with the best possibel accuracy. This function also ensures adding the map view and the navigation bar to the screen.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // settings of the location manager
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        //adding the main map view
        let zooPlanMapView = MKMapView()
        self.view.addSubview(zooPlanMapView)
        zooPlanMapView.showsUserLocation = true
        zooPlanMapView.delegate = self
        zooPlanMapView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.height * 3 / 5)
        }
        // setting of the ZOO plan map view for further work
        self.zooPlanMapView = zooPlanMapView
        
        // settings of the navigation bar and its items
        self.navigationController?.isToolbarHidden = false
        let goToSettingsButton = UIBarButtonItem(title:NSLocalizedString("goToSettings", comment: ""), style: .plain, target: self, action: #selector(goToSettingsTapped(_:)))
        let goToSettingsOfLocalityButton = UIBarButtonItem(title:NSLocalizedString("goForSelectionOfLocality", comment: ""), style: .plain, target: self, action: #selector(goForSelectionOfLocalityTapped(_:)))
        let goToAnimalListButton = UIBarButtonItem(title: NSLocalizedString("goToAnimalList", comment:""), style: .plain, target: self, action: #selector(goToAnimalListTapped(_:)))
        
        let arr: [Any] = [goToSettingsButton, goToSettingsOfLocalityButton, goToAnimalListButton]
        setToolbarItems(arr as? [UIBarButtonItem], animated: true)
        
        
        // adding loaded localities to map
        self.addLoadedLocalitiesToMap()
        
        
        // registration of the actions for saying information about localities and animals in the closeness of the actual location
        self.viewModel.animalInClosenessAction.values.producer.startWithValues{ (animal) in
            self.viewModel.sayInformationAboutAnimal(animal: animal)
        }
        
        self.viewModel.localityInClosenessAction.values.producer.startWithValues{ locality in
            self.viewModel.sayInformationAboutLocality(locality: locality)
        }
        
    }
    
    
    /**
     This function ensures drawing the shortest path for walking from the actual place to the selected locality. This function finds the shortest path to the selected locality and then it ensures it drawing on the map.
     */
    func drawRouteToTheSelectedTargetLocality(){
        let selectedLocality = SelectLocalityViewModel.selectedLocality
        if(selectedLocality != nil){
            // creating an object with coordinates of the selected locality and placemarks
            let coordinatesForDestinationPlacemark = CLLocationCoordinate2D(latitude: selectedLocality!.latitude, longitude: selectedLocality!.longitude)
            let sourcePlacemark = MKPlacemark(coordinate: self.zooPlanMapView.userLocation.coordinate)
            let destinationPlacemark = MKPlacemark(coordinate: coordinatesForDestinationPlacemark)
            
            // creating the direction request with the created placemarks
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.transportType = .walking
            
            // calculating the shortest path to the target selected location
            let directions = MKDirections(request: directionRequest)
            directions.calculate{ (response, error) in
                guard let directionResponse = response else {
                    self.view.backgroundColor = .red
                    return
                }
                self.view.backgroundColor = .white
                let routes = directionResponse.routes
                
                // finding the shortest route from the array of routes
                var shortestRoute = routes[0]
                var shortestDistance = shortestRoute.distance
                for route in routes{
                    if(route.distance < shortestDistance){
                        shortestRoute = route
                        shortestDistance = route.distance
                    }
                }
                
                // removing of the old drawed path and adding actuall path to the selected destination
                self.zooPlanMapView.removeOverlays(self.zooPlanMapView.overlays)
                self.zooPlanMapView.addOverlay(shortestRoute.polyline, level: .aboveRoads)
            }
        } else {
            self.zooPlanMapView.removeOverlays(self.zooPlanMapView.overlays)
        }
    }
    
    /**
        This function ensures adding markers of localities and animals with coordintates to the map of the ZOO. In this method there are registered actions to add markers of localities and animals. Actions to get the list of localities with given coordinates and the list of animals with given coordinates are started here.
     */
    func addLoadedLocalitiesToMap(){
        // adding annotations of localities (especially pavilions) with known coordinates to the map
        self.viewModel.getLocalitiesAction.values.producer.startWithValues {(localitiesList) in
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
        self.viewModel.getAnimalsAction.values.producer.startWithValues { (animalList) in
            for animal in animalList{
                // making and adding an annotation of the actual animal to the map
                let annotation: MKPointAnnotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: animal.latitude, longitude: animal.longitude)
                annotation.coordinate = coordinate
                annotation.title = animal.title
                self.zooPlanMapView.addAnnotation(annotation)
            }
        }
        
        //running actions - getting localities and animals from the view model
        self.viewModel.getLocalitiesAction.apply().start()
        self.viewModel.getAnimalsAction.apply().start()
    }
    
    /**
     This function is called each time when location was updated. In this function there are updated informations about location in the view model. There are also run actions for saying information about an animal or a locality which is close to the actual position
     
     - Parameters:
        - manager: The location manager
        - locations: The array of locations in which can be the actual location
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.viewModel.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.viewModel.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            self.viewModel.localityInClosenessAction.apply().start()
            self.viewModel.animalInClosenessAction.apply().start()
            
            self.drawRouteToTheSelectedTargetLocality()
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
    
    
    /**
     This function ensures going to the screen with list of all animals.
     
     - Parameters:
        - sender: The bar button item on which user who wants to go to the animal list clicked
     */
    @objc
    private func goToAnimalListTapped(_ sender: UIBarButtonItem){
        flowDelegate?.goToAnimalListTapped(in: self)
    }
    
    
    /**
     This function ensures going to the screen for selection of a target locality where user wants to go.
     
     - Parameters:
        - sender: The bar button item which ensures taking the user to the list of localities to select as the target
     */
    @objc
    private func goForSelectionOfLocalityTapped(_ sender: UIBarButtonItem){
        flowDelegate?.goForSelectionOfLocality(in: self)
    }
    
    
    /**
     This function ensures going to the screen for settings which information about animals will be said.
     
     - Parameters:
        - sender: The bar button item which ensures taking user to the screen for setting of the information which will be said
     */
    @objc
    private func goToSettingsTapped(_ sender: UIBarButtonItem){
        flowDelegate?.goToSettings(in: self)
    }

}
