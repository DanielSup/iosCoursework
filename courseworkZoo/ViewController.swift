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
import ReactiveSwift


class ViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    private var localityViewModel: LocalityViewModelling
    private var animalViewModel: AnimalViewModelling
    weak var flowDelegate: GoToAnimalListDelegate?
    
    private weak var zooPlanMapView: MKMapView!
    private weak var setVisibilityOfTextButton: UIButton!
    private weak var versionLabel: UILabel!
    private weak var buildNumberLabel: UILabel!
    
    private var lastAnnotation: MKAnnotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    
    init(localityViewModel: LocalityViewModelling, animalViewModel: AnimalViewModelling){
        self.localityViewModel = localityViewModel
        self.animalViewModel = animalViewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.localityViewModel = LocalityViewModel(dependencies: AppDependency.shared)
        self.animalViewModel = AnimalViewModel(dependencies: AppDependency.shared)
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
        goToAnimalListButton.setTitle("Seznam zvirat", for: .normal)
        goToAnimalListButton.setTitleColor(.black, for: .normal)
        goToAnimalListButton.addTarget(self, action: #selector(goToAnimalListTapped(_:)), for: .touchUpInside)
        view.addSubview(goToAnimalListButton)
        goToAnimalListButton.snp.makeConstraints{
            (make) in
            make.right.equalTo(view)
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
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = NSLocalizedString("here", comment: "")
        zooPlanMapView.isZoomEnabled = true
        zooPlanMapView.isScrollEnabled = true
        zooPlanMapView.isPitchEnabled = true
        zooPlanMapView.setRegion(region, animated: true)
        zooPlanMapView.addAnnotation(annotation)
        self.lastAnnotation = annotation
        zooPlanMapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        zooPlanMapView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.width.equalTo(view.bounds.width * 4 / 5)
            make.height.equalTo(view.bounds.height * 4 / 5)
        }
        self.zooPlanMapView = zooPlanMapView       //self.animalViewModel.readInformationAboutAnimals()
        self.addLoadedLocalitiesToMap()
    }
    
    func addLoadedLocalitiesToMap(){

        print("Adding localities")
    self.localityViewModel.getLocalitiesAction.values.producer.startWithValues {(localitiesList) in
            print("Locality values")
            print(localitiesList)
            for locality in localitiesList{
                let annotation: MKPointAnnotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: locality.latitude, longitude: locality.longitude)
                annotation.coordinate = coordinate
                annotation.title = locality.title
                self.zooPlanMapView.addAnnotation(annotation)
            }
        }
        
    self.animalViewModel.getAnimalsAction.errors.producer.startWithValues {
            (errors) in
            print("Error")
            print(errors)
        }
    self.animalViewModel.getAnimalsAction.values.producer.startWithValues { (animalList) in
            print("Animal values")
            for animal in animalList{
                let annotation: MKPointAnnotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: animal.latitude, longitude: animal.longitude)
                annotation.coordinate = coordinate
                annotation.title = animal.title
                self.zooPlanMapView.addAnnotation(annotation)
            }
        }
    self.animalViewModel.animalInClosenessAction.values.producer.startWithValues{ (animal) in
            self.animalViewModel.sayInformationAboutAnimal(animal: animal)
            
        }
    self.localityViewModel.localityInClosenessAction.values.producer.startWithValues{ locality in
            self.localityViewModel.sayInformationAboutLocality(locality: locality)
        }
        
        self.localityViewModel.getLocalitiesAction.apply().start()
        self.animalViewModel.getAnimalsAction.apply().start()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            self.animalViewModel.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.localityViewModel.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.localityViewModel.localityInClosenessAction.apply().start()
        
            self.animalViewModel.animalInClosenessAction.apply().start()
            
            self.zooPlanMapView.removeAnnotation(self.lastAnnotation)
            self.zooPlanMapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = NSLocalizedString("here", comment: "")
            self.zooPlanMapView.addAnnotation(annotation)
            self.lastAnnotation = annotation
        }
    }

    @objc
    private func goToAnimalListTapped(_ sender: UIButton){
        print("Go to animal list tapped")
        print(flowDelegate)
        flowDelegate?.goToAnimalListTapped(in: self)
    }

}

