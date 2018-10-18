//
//  NewStoryViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/18/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import MapKit

class NewStoryViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /*
     CategoryPicker functions
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categories.count
        }
        else {
            return subcategories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categories[row]
        }
        else {
            return subcategories[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            print (categories[row])
            publishingCategory = categories[row]
            //RELOAD SUBCATEGORIES TO MATCH
            if publishingCategory == "TWO" {
                subcategories = ["DO", "RE"]
                subcategoryPicker.reloadAllComponents()
            }
        }
        else {
            publishingSubcategory = subcategories[row]
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var subcategoryPicker: UIPickerView!
    var categories = ["ONE", "TWO", "THREE"]
    var subcategories = [String]()
    
    var publishingCenterCoordinate = CLLocationCoordinate2D()
    var publishingCategory = ""
    var publishingSubcategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FILL CATEGORIES - fill subcategories after category selected using reloadComponent
        
        mapView.delegate = self
        centerMapOnLocation()       //Center map on College Park
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        self.subcategoryPicker.delegate = self
        self.subcategoryPicker.dataSource = self
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
        print ("publishing center: \(coordinate)")
        publishingCenterCoordinate = coordinate
    }
}
