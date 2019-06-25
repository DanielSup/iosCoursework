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
    private var selectedLocality: CLLocationCoordinate2D? = nil
    
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
    
    func drawRouteToTheSelectedTargetLocality(){
        if(self.selectedLocality != nil){
            // creating an object with coordinates of the selected locality
            let coordinatesForDestinationPlacemark = CLLocationCoordinate2D(latitude: self.selectedLocality!.latitude, longitude: self.selectedLocality!.longitude)
            // creating placemarks
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
            
            self.zooPlanMapView.setCenter(center, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = NSLocalizedString("here", comment: "")
            
            self.drawRouteToTheSelectedTargetLocality()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }

    @objc
    private func goToAnimalListTapped(_ sender: UIBarButtonItem){
        flowDelegate?.goToAnimalListTapped(in: self)
    }

    @objc
    private func goForSelectionOfLocalityTapped(_ sennder: UIBarButtonItem){
        flowDelegate?.goForSelectionOfLocality(in: self)
    }
    
    @objc
    private func goToSettingsTapped(_ sennder: UIBarButtonItem){
        flowDelegate?.goToSettings(in: self)
    }
    
}

