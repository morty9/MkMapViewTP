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
import CoreData

class MapViewController: MyViewController, UIGestureRecognizerDelegate{

    public var context: NSManagedObjectContext!
    
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
        
        //let viewRegion = MKCoordinateRegionMakeWithDistance((self.locationManager.location?.coordinate)!, 350, 350)
        //self.mapView.setRegion(viewRegion, animated: false)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.fetchRequest()
    }
    
    fileprivate func fetchRequest() {
        let request: NSFetchRequest<Stores> = Stores.fetchRequest()
        guard let result = try? self.context.fetch(request) else {
            return
        }
        result.forEach { self.mapView.addAnnotation( $0.annotation ) }
    }
    
    func getAdress(location : CLLocationCoordinate2D) {

        let geocoder = CLGeocoder()
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                print(firstLocation ?? "")
                let newAppleStoreViewController = NewAppleStoreViewController()
                newAppleStoreViewController.delegate = self
                let street = placemarks?[0].addressDictionary!["Street"] as! String
                let zip = placemarks?[0].addressDictionary!["ZIP"] as! String
                let city = placemarks?[0].addressDictionary!["City"] as! String
                let address = street + " " + zip + " " + city
                    
                newAppleStoreViewController.address = address
                newAppleStoreViewController.lng = String(location.longitude)
                newAppleStoreViewController.lat = String(location.latitude)
                newAppleStoreViewController.context = self.context
                
                self.dismiss(animated: true, completion: nil)
                self.present(PortraitNavigationController(rootViewController: newAppleStoreViewController), animated: true)
            }
        })
    }
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        self.getAdress(location: coordinate)
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    
}

extension Stores {
    
    public var annotation: MKAnnotation {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.title = self.name
        pointAnnotation.coordinate.latitude = self.latitude
        pointAnnotation.coordinate.longitude = self.longitude
        
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
            let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: MapViewController.appleStoreIdentifier)
            pin.image = UIImage(named: "maps-and-flags")
            return pin
        }
    }
    
}

extension MapViewController: NewAppleStoreViewControllerDelegate {
    
    func newAppleStoreViewController(_ newAppleStoreViewController: NewAppleStoreViewController, didCreateStore store: Stores) {
        newAppleStoreViewController.dismiss(animated: true)
    }
    
}

