//
//  NewStoryViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/18/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import MapKit

class NewStoryViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        centerMapOnLocation()       //Center map on College Park
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    /*
     Function to center map on College Park
     */
    func centerMapOnLocation() {
        let regionRadius: CLLocationDistance = 1500
        let coordinate = CLLocationCoordinate2D(latitude: 38.989697, longitude: -76.937759)
        let coordinateRegion = MKCoordinateRegion(center: coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation:
        print ("HI")
        print (coordinate)
    }
}
