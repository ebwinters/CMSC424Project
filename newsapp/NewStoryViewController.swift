//
//  NewStoryViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/18/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import MapKit
import Firebase

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
            publishingCategory = categories[0]      //Set to top item
            return categories[row]
        }
        else {
            if subcategories.count > 0 {
                publishingSubcategory = subcategories[0]    //Set to top item
            }
            print (publishingSubcategory)
            return subcategories[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            publishingCategory = categories[row]        //Set the publishing category to whatever publisher selects
            //RELOAD SUBCATEGORIES TO MATCH
            subcategories = [String]()      //Reset this and reload correct
            ref.child("Categories").observeSingleEvent(of: .value) { snapshot in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    if self.publishingCategory == rest.key {       //If this is the one we clicked
                        let children = rest.children.allObjects as! [DataSnapshot]       //Get all subcategories for category we clicked switch for
                        for child in children {
                            self.subcategories.append(child.value as! String)
                        }
                    }
                }
                self.subcategoryPicker.reloadAllComponents()        //Load all subcategories for currently selected category
            }
        }
        else {
            publishingSubcategory = subcategories[row]      //Set publishing subcategory to the currently selected one, if they want
        }
    }
    
    var ref = Database.database().reference()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var subcategoryPicker: UIPickerView!
    //TODO: MAKE THIS NOT STATIC
    var categories = ["Politics", "Sports"]
    var subcategories = [String]()
    
    var publishingCenterCoordinate = CLLocationCoordinate2D()       //Center for publisher's story
    var publishingCategory = ""     //Category for publisher's story
    var publishingSubcategory = ""  //Subcategory for publisher's story
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: FILL CATEGORIES - fill subcategories after category selected using reloadComponent
        
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
    
    /*
     Handle map tap and update center location to wherever publisher clicks on map using a gestureRecognizer
     */
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)

        print ("publishing center: \(coordinate)")
        publishingCenterCoordinate = coordinate
    }
}
