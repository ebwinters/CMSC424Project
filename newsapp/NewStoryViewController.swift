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
import FirebaseStorage

class NewStoryViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /*
     Create a pin to show publisher where their center is on map
     */
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
            if subcategories[row] != "None" {
                return subcategories[row]
            }
            else {
                return ""
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            publishingCategory = categories[row]        //Set the publishing category to whatever publisher selects
            print (publishingCategory)
            //RELOAD SUBCATEGORIES TO MATCH
            subcategories = [String]()      //Reset this and reload correct
            ref.child("Categories").observeSingleEvent(of: .value) { snapshot in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    if self.publishingCategory == rest.key {       //If this is the one we clicked
                        let children = rest.children.allObjects as! [DataSnapshot]       //Get all subcategories for category we clicked switch for
                        for child in children {
                            self.subcategories.append(child.value as! String)
                        }
                        self.subcategories.append("None")
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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var subcategoryTextField: UITextField!
    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    
    
    var categories = ["None selected"]
    var subcategories = [String]()
    
    var publisherID = ""
    var publishingCenterCoordinate = ("", "")    //Center for publisher's story
    var publishingCategory = ""     //Category for publisher's story
    var publishingSubcategory = ""  //Subcategory for publisher's story
    var dateAvailable = ""
    var range = 0
    var message = ""
    var storyTitle = ""
    var pubName = ""
    var image = UIImage()
    
    @objc func handleUploadImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //info is a dictionary
        if let originalImage = info[.originalImage] {
            image = originalImage as! UIImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPublisherName(publisherID: publisherID)
        self.navigationController?.isNavigationBarHidden = false
        imageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImage)))
        //Fill categories - fill subcategories after category selected using reloadComponent
        ref.child("Categories").observeSingleEvent(of: .value) { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.categories.append(rest.key)
            }
            self.categoryPicker.reloadAllComponents()
        }
        mapView.delegate = self
        centerMapOnLocation()       //Center map on College Park
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
        rangeTextField.keyboardType = UIKeyboardType.numberPad      //Range only integers in miles
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        self.subcategoryPicker.delegate = self
        self.subcategoryPicker.dataSource = self
    }
    
    @IBAction func submitStory(_ sender: Any) {
        if categoryTextField.text! != "" {
            publishingCategory = categoryTextField.text!
        }
        if subcategoryTextField.text! != "" {
            publishingSubcategory = subcategoryTextField.text!
        }
        if publishingCategory == "None selected" {
            publishingCategory = categoryTextField.text!
            publishingSubcategory = subcategoryTextField.text!
        }
        message = messageField.text!
        storyTitle = titleField.text!
        range =  Int(rangeTextField.text!)!
        
        //Add a new category and subcategory if needed
        if categories.contains(publishingCategory) == false {
            self.ref.child("Categories").child(publishingCategory).childByAutoId().setValue("None")     //Add new subcategory subscription for user with userID
            
            if publishingSubcategory != "" {
                self.ref.child("Categories").child(publishingCategory).childByAutoId().setValue(publishingSubcategory)
            }
        }
        if categories.contains(publishingCategory) == true {
            //Get subcategories for category
            var innerSubcategories = [String]()
            ref.child("Categories").observeSingleEvent(of: .value) { snapshot in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    if self.publishingCategory == rest.key {       //If this is the one we clicked
                        let children = rest.value as! NSDictionary       //Get all subcategories
                        for child in children {
                            if child.value as! String != "None" {
                                innerSubcategories.append(child.value as! String)
                            }
                        }
                    }
                }
                if innerSubcategories.contains(self.publishingSubcategory) == false && self.publishingSubcategory != "" {
                    self.ref.child("Categories").child(self.publishingCategory).childByAutoId().setValue(self.publishingSubcategory)     //Add new subcategory under category
                }
            }
            
        }
        //Store image
        let data = Data()
        let storageRef = Storage.storage().reference().child(storyTitle+publisherID+".jpg")
        let uploadData = image.jpegData(compressionQuality: 1)!
        print (image.size)
        let uploadTask = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if error != nil {
                print (error)
                return
            }
            guard let metadata = metadata else {
                return
            }
        }

        
        
        let center = [
            "latitude": publishingCenterCoordinate.0,
            "longitude": publishingCenterCoordinate.1
        ]
        let post = [
            "category": publishingCategory,
            "subcategory": publishingSubcategory,
            "message": message,
            "title": storyTitle,
            "end": dateAvailable,
            "center": center,
            "range": range,
            "publisherName": pubName
            ] as [String : Any]
        let postRef = self.ref.child("News").childByAutoId()
        postRef.setValue(post)     //Add to news
        //Make new publishes entry under publisher with newsID: category name
        self.ref.child("Publishes").child(publisherID).child(postRef.key!).setValue(["Category": publishingCategory])
        //Segue
        performSegue(withIdentifier: "publishedStory", sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "publishedStory") {       //User signed in successfully
            let destinationVC = segue.destination as!   publisherAuthenticatedViewControllerViewController
            destinationVC.hidden = true
            destinationVC.publisherID = publisherID
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
    
    func getPublisherName(publisherID: String) {
        var name = ""
        ref.child("Publishers").child(publisherID).observeSingleEvent(of: .value) { snapshot in
            let snap = snapshot.value as! NSDictionary
            name = snap["name"] as! String
            self.pubName = name
        }
    }
    
    
    
    /*
     Handle map tap and update center location to wherever publisher clicks on map using a gestureRecognizer
     */
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)

        print ("publishing center: \(coordinate)")
        publishingCenterCoordinate = (String(format:"%f", coordinate.latitude), String(format:"%f", coordinate.longitude))
        mapView.removeAnnotations(self.mapView.annotations)
        mapView.addAnnotation(MapPin(coordinate: coordinate, title: "Center Location", subtitle: ""))   //Plot on map
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateAvailable = dateFormatter.string(from: sender.date)
    }
}
