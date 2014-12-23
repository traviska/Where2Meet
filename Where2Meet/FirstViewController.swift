//
//  FirstViewController.swift
//  Where2Meet
//
//  Created by Ray Badger on 06/10/2014.
//  Copyright (c) 2014 TKA. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate  {
    
    var geocoder: CLGeocoder?
    let locationManager = CLLocationManager()
    
    let appDele = UIApplication.sharedApplication().delegate as AppDelegate

    @IBOutlet var addView: UIView!
    
    @IBOutlet var postcodeField: UITextField!
    @IBOutlet weak var lookupIndicator: UIActivityIndicatorView!
    @IBOutlet var locationList: UITableView!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet weak var addCurrentButton: UIButton!
    
    @IBAction func addLocation(sender: UIButton) {
        if (!postcodeField.text.isEmpty) {
            self.getPlacemarkFromLocation(postcodeField.text)
            
            lookupIndicator.startAnimating()
        }
    }
    
    @IBAction func addCurrentLocation() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        lookupIndicator.startAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make the keyboard disappear upon return
        postcodeField.delegate = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDele.postcodes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.locationList.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        
        var cellLabelText = appDele.postcodes[indexPath.row]
        var newLocation: CLLocationCoordinate2D = appDele.coordinates[indexPath.row]
        cellLabelText += " Lat: \(newLocation.latitude) Lon: \(newLocation.longitude)"
        cell.textLabel?.text = cellLabelText
        return cell
    }
    
    // called when a row deletion action is confirmed
    func tableView(tableView: UITableView!,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath!) {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the model
                appDele.postcodes.removeAtIndex(indexPath.row)
                appDele.coordinates.removeAtIndex(indexPath.row)
                
                // remove the deleted item from the `UITableView`
                self.locationList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }

    func getPlacemarkFromLocation(postCode: String) {
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(postCode, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.appDele.postcodes.append(self.postcodeField.text)
                var latitude = placemark.location.coordinate.latitude
                var longitude = placemark.location.coordinate.longitude
                
                var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude,longitude: longitude)
                self.didReceiveGeocodeAddress(location)
            }
        })
    }
    
    func didReceiveGeocodeAddress(location: CLLocationCoordinate2D) {

        appDele.coordinates.append(location)
        self.locationList.reloadData()
        self.lookupIndicator.stopAnimating()
        self.locationList.editing = true
        postcodeField.text = ""
    }
    

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error \(error.localizedDescription)")
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                println("Current postcode = \(pm.postalCode)")
                self.appDele.postcodes.append(pm.postalCode)
                
                var latitude = manager.location.coordinate.latitude
                var longitude = manager.location.coordinate.longitude
                var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude,longitude: longitude)
                self.didReceiveGeocodeAddress(location)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location \(error.localizedDescription)")
    }

}

