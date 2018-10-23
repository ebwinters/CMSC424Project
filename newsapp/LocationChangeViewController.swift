//
//  LocationChangeViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/23/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import MapKit

class LocationChangeViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    class MapPin : NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        
        init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    var newLocation = CLLocationCoordinate2D()
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        centerMapOnLocation()       //Center map on College Park
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updatedLocation" {
            let destinationVC = segue.destination as! userAuthenticatedViewController
            destinationVC.currentLocation = newLocation
            destinationVC.userID = userID
        }
    }
    
    /*
     Function to center map on College Park
     */
    func centerMapOnLocation() {
        let regionRadius: CLLocationDistance = 2000
        let coordinate = CLLocationCoordinate2D(latitude: 38.989697, longitude: -76.937759)
        let coordinateRegion = MKCoordinateRegion(center: coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /*
     Handle map tap and update center location to wherever publisher clicks on map using a gestureRecognizer
     */
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        print ("publishing center: \(coordinate)")
        newLocation = coordinate
        mapView.removeAnnotations(self.mapView.annotations)
        mapView.addAnnotation(MapPin(coordinate: coordinate, title: "Center Location", subtitle: ""))   //Plot on map
    }
    
    
    @IBAction func confirmPress(_ sender: Any) {
        performSegue(withIdentifier: "updatedLocation", sender: (Any).self)
    }
    
}
