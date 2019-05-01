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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    private weak var zooPlanMapView: MKMapView!
    private weak var setVisibilityOfTextButton: UIButton!
    private var lastAnnotation: MKAnnotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let textToRead = UILabel()
        textToRead.text = NSLocalizedString("welcome", comment: "")
        self.view.addSubview(textToRead)
        textToRead.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(30)
        }
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
        zooPlanMapView.setRegion(region, animated: true)
        zooPlanMapView.addAnnotation(annotation)
        self.lastAnnotation = annotation
        zooPlanMapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        zooPlanMapView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        self.zooPlanMapView = zooPlanMapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        self.zooPlanMapView.removeAnnotation(self.lastAnnotation)
            self.zooPlanMapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = NSLocalizedString("here", comment: "")
            self.zooPlanMapView.addAnnotation(annotation)
            self.lastAnnotation = annotation
        }
    }


}

