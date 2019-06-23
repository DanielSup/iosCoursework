//
//  ViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 27/04/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import SwiftyGif
import ReactiveSwift


class ViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    private var viewModel: ViewModelling
    weak var flowDelegate: GoToAnimalListDelegate?
    
    private weak var zooPlanMapView: MKMapView!
    private weak var zooPlanMapViewSmall: MKMapView!
    private weak var setVisibilityOfTextButton: UIButton!
    private weak var versionLabel: UILabel!
    private weak var buildNumberLabel: UILabel!
    private var selectedAnnotation: MKAnnotation? = nil
    
    private var selectedLocality: CLLocationCoordinate2D? = nil
    
    private var lastAnnotation: MKAnnotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    
    init(viewModel: ViewModelling){
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = ViewModel(dependencies: AppDependency.shared)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        let versionLabel = UILabel()
        let buildNumberLabel = UILabel()
        print(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion"))
        versionLabel.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "a"
        buildNumberLabel.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "a"
        versionLabel.backgroundColor = .white
        buildNumberLabel.backgroundColor = .white
        versionLabel.textColor = .black
        buildNumberLabel.textColor = .black
        view.addSubview(versionLabel)
        view.addSubview(buildNumberLabel)
        versionLabel.snp.makeConstraints{
            (make) in
            make.left.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(50)
        }
        buildNumberLabel.snp.makeConstraints{
            (make) in
            make.left.equalTo(versionLabel.snp.right)
            make.bottom.equalTo(versionLabel.snp.bottom)
            make.height.equalTo(50)
        }
        
        let goToAnimalListButton = UIButton()
        goToAnimalListButton.setTitle(NSLocalizedString("goToAnimalList", comment: ""), for: .normal)
        goToAnimalListButton.setTitleColor(.black, for: .normal)
        goToAnimalListButton.addTarget(self, action: #selector(goToAnimalListTapped(_:)), for: .touchUpInside)
        view.addSubview(goToAnimalListButton)
        goToAnimalListButton.snp.makeConstraints{
            (make) in
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(50)
        }
        
        let goToLocalityListButton = UIButton()
        goToLocalityListButton.setTitle(NSLocalizedString("goForSelectionOfLocality", comment: ""), for: .normal)
        goToLocalityListButton.setTitleColor(.black, for: .normal)
        goToLocalityListButton.addTarget(self, action: #selector(goForSelectionOfLocalityTapped(_:)), for: .touchUpInside)
        view.addSubview(goToLocalityListButton)
        goToLocalityListButton.snp.makeConstraints{
            (make) in
            make.right.equalTo(goToAnimalListButton.snp.left)
            make.bottom.equalTo(view)
            make.height.equalTo(50)
        }
        
        
        let goToSettingsButton = UIButton()
        goToSettingsButton.setTitle(NSLocalizedString("goToSettings", comment: ""), for: .normal)
        goToSettingsButton.setTitleColor(.black, for: .normal)
        goToSettingsButton.addTarget(self, action: #selector(goToSettingsTapped(_:)), for: .touchUpInside)
        view.addSubview(goToSettingsButton)
        goToSettingsButton.snp.makeConstraints{
            (make) in
            make.right.equalTo(goToLocalityListButton.snp.left)
            make.bottom.equalTo(view)
            make.height.equalTo(50)
        }
        
        self.versionLabel = versionLabel
        self.buildNumberLabel = buildNumberLabel
        
        let zooPlanMapView = MKMapView()
        self.view.addSubview(zooPlanMapView)
        var center = CLLocationCoordinate2D(latitude: 49.9720359488, longitude: 14.16588306427)
        if let coor = zooPlanMapView.userLocation.location?.coordinate {
            center = coor
        }
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
        
        let regionOfSmallMap = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = NSLocalizedString("here", comment: "")
        zooPlanMapView.setRegion(region, animated: true)
        zooPlanMapView.addAnnotation(annotation)
        self.lastAnnotation = annotation
        zooPlanMapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        zooPlanMapView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.height * 3 / 5)
        }
        self.zooPlanMapView = zooPlanMapView
        let zooPlanMapViewSmall = MKMapView()
        self.view.addSubview(zooPlanMapViewSmall)
        zooPlanMapViewSmall.setRegion(regionOfSmallMap, animated: true)
        zooPlanMapViewSmall.addAnnotation(annotation)
        zooPlanMapViewSmall.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(zooPlanMapView.snp.bottom)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.height * 1 / 5)
        }
        self.zooPlanMapViewSmall = zooPlanMapViewSmall
        self.zooPlanMapView.delegate = self
        self.zooPlanMapViewSmall.delegate = self
        
        self.addLoadedLocalitiesToMap()
    }
    
    func drawRouteToFirstLocality(){
        if(self.selectedLocality != nil){
            let sourcePlacemark = MKPlacemark(coordinate: self.lastAnnotation.coordinate)
            let destinationPlacemark = MKPlacemark(coordinate: self.selectedLocality!)
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.transportType = .walking
            let directions = MKDirections(request: directionRequest)
            directions.calculate{ (response, error) in
                guard let directionResponse = response else {
                    self.view.backgroundColor = .red
                    return
                }
                self.view.backgroundColor = .white
                let routes = directionResponse.routes
                var shortestRoute = routes[0]
                var shortestDistance = shortestRoute.distance
                for route in routes{
                    if(route.distance < shortestDistance){
                        shortestRoute = route
                        shortestDistance = route.distance
                    }
                }
                self.zooPlanMapView.removeOverlays(self.zooPlanMapView.overlays)
                self.zooPlanMapView.addOverlay(shortestRoute.polyline, level: .aboveRoads)
                self.zooPlanMapViewSmall.removeOverlays(self.zooPlanMapViewSmall.overlays)
                self.zooPlanMapViewSmall.addOverlay(shortestRoute.polyline, level: .aboveRoads)
            }
        } else {
            self.zooPlanMapView.removeOverlays(self.zooPlanMapView.overlays)
            self.zooPlanMapViewSmall.removeOverlays(self.zooPlanMapViewSmall.overlays)
        }
    }
    
    func addActuallySelectedDestinationToSmallPlan(){
        if (self.selectedAnnotation != nil){
            self.zooPlanMapViewSmall.removeAnnotation(self.selectedAnnotation!)
        }
        if (SelectLocalityViewModel.selectedLocality != nil){
            let annotation = MKPointAnnotation()
            let locality = SelectLocalityViewModel.selectedLocality!
            annotation.title = locality.title
            let coordination = CLLocationCoordinate2D(latitude: locality.latitude, longitude: locality.longitude)
            annotation.coordinate = coordination
            self.zooPlanMapViewSmall.addAnnotation(annotation)
            self.selectedAnnotation = annotation
        }
    }
    
    func addLoadedLocalitiesToMap(){
        self.viewModel.getLocalitiesAction.values.producer.startWithValues {(localitiesList) in           for locality in localitiesList{
                let annotation: MKPointAnnotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: locality.latitude, longitude: locality.longitude)
                annotation.coordinate = coordinate
                annotation.title = locality.title
                self.zooPlanMapView.addAnnotation(annotation)
            }
        }

        self.viewModel.getAnimalsAction.values.producer.startWithValues { (animalList) in
            for animal in animalList{
                let annotation: MKPointAnnotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: animal.latitude, longitude: animal.longitude)
                annotation.coordinate = coordinate
                annotation.title = animal.title
                self.zooPlanMapView.addAnnotation(annotation)
            }
        }
        self.viewModel.animalInClosenessAction.values.producer.startWithValues{ (animal) in
            self.viewModel.sayInformationAboutAnimal(animal: animal)
            
        }
        self.viewModel.localityInClosenessAction.values.producer.startWithValues{ locality in
            self.viewModel.sayInformationAboutLocality(locality: locality)
        }
        
        self.viewModel.getLocalitiesAction.apply().start()
        self.viewModel.getAnimalsAction.apply().start()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if(SelectLocalityViewModel.selectedLocality != nil){
            let actualLocality = SelectLocalityViewModel.selectedLocality!
            self.selectedLocality = CLLocationCoordinate2D(latitude: actualLocality.latitude, longitude: actualLocality.longitude)
        } else {
            self.selectedLocality = nil
        }
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.viewModel.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.viewModel.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.viewModel.localityInClosenessAction.apply().start()
        
            self.viewModel.animalInClosenessAction.apply().start()
            
            self.zooPlanMapView.removeAnnotation(self.lastAnnotation)
            self.zooPlanMapViewSmall.removeAnnotation(self.lastAnnotation)
            self.zooPlanMapView.setCenter(center, animated: true)
            if (SelectLocalityViewModel.selectedLocality == nil){
                self.zooPlanMapViewSmall.setCenter(center, animated: true)
            } else {
                let selectedLocality = SelectLocalityViewModel.selectedLocality!
                let middleLatitude = (location.coordinate.latitude + selectedLocality.latitude)/2.0
                let middleLongitude = (location.coordinate.longitude + selectedLocality.longitude)/2.0
                let center = CLLocationCoordinate2D(latitude: middleLatitude, longitude: middleLongitude)
                let latitudeDelta = abs(location.coordinate.latitude - middleLatitude) * 3.0
                let longitudeDelta = abs(location.coordinate.longitude - middleLongitude) * 3.0
                let regionOfSmallMap = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
                self.zooPlanMapViewSmall.setRegion(regionOfSmallMap, animated: true)
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = NSLocalizedString("here", comment: "")
            self.zooPlanMapView.addAnnotation(annotation)
            self.zooPlanMapViewSmall.addAnnotation(annotation)
            self.lastAnnotation = annotation
            self.drawRouteToFirstLocality()
            self.addActuallySelectedDestinationToSmallPlan()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }

    @objc
    private func goToAnimalListTapped(_ sender: UIButton){
        flowDelegate?.goToAnimalListTapped(in: self)
    }

    @objc
    private func goForSelectionOfLocalityTapped(_ sennder: UIButton){
        flowDelegate?.goForSelectionOfLocality(in: self)
    }
    
    @objc
    private func goToSettingsTapped(_ sennder: UIButton){
        flowDelegate?.goToSettings(in: self)
    }
    
}

