//
//  FirstViewController.swift
//  Where2Meet
//
//  Created by Ray Badger on 06/10/2014.
//  Copyright (c) 2014 TKA. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var geocoder: CLGeocoder?
    
    let appDele = UIApplication.sharedApplication().delegate as AppDelegate
    
    @IBOutlet var postcodeField: UITextField!
    @IBOutlet weak var lookupIndicator: UIActivityIndicatorView!
    @IBOutlet var locationList: UITableView!
    
    @IBOutlet var addButton: UIButton!
    
    @IBAction func addLocation(sender: UIButton) {
        if (!postcodeField.text.isEmpty) {
            self.getPlacemarkFromLocation(postcodeField.text)
            appDele.postcodes.append(postcodeField.text)
            lookupIndicator.startAnimating()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}

