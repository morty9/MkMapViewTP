//
//  MapViewController.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 15/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    weak var storeProvider: StoreProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            let manager = CLLocationManager()
            manager.requestWhenInUseAuthorization()
            self.locationManager = manager
        }
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        if let stores = self.storeProvider?.stores {
            self.mapView.addAnnotations(stores.map { $0.annotation })
        }
    }
    
}

extension Store {
    
    public var annotation: MKAnnotation {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.title = self.name
        pointAnnotation.coordinate = self.coordinate
        return pointAnnotation
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    public static let appleStoreIdentifier = "ASI"
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }
        
        if let reused = mapView.dequeueReusableAnnotationView(withIdentifier: MapViewController.appleStoreIdentifier) {
            reused.annotation = annotation
            return reused
        } else {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapViewController.appleStoreIdentifier)
            pin.canShowCallout = true
            pin.pinTintColor = .blue
            return pin
        }
    }
    
}
