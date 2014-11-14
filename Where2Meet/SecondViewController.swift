//
//  SecondViewController.swift
//  Where2Meet
//
//  Created by Ray Badger on 06/10/2014.
//  Copyright (c) 2014 TKA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController {

    var geocoder: CLGeocoder?
    
    let appDele = UIApplication.sharedApplication().delegate as AppDelegate
    
    @IBOutlet var mapView: MKMapView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        if self.mapView.overlays != nil {
            for overlayToRemove in self.mapView.overlays {
                if overlayToRemove is MKPolyline {
                    mapView.removeOverlay(overlayToRemove as MKOverlay)
                }
            }
        }

        // 1
        let location = calcAverageLocation()
        
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // 2.5
        for coord in appDele.coordinates {
            let c1 = location
            let c2 = coord
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.addOverlay(polyline)
        }

        var placemarks:NSMutableArray = NSMutableArray()
        var myRequest = MKLocalSearchRequest()
        myRequest.naturalLanguageQuery = "pub"

        myRequest.region = self.mapView.region //need to define region later
        var search = MKLocalSearch(request: myRequest)
        search.startWithCompletionHandler {
            (response:MKLocalSearchResponse!, error:NSError!) in
            if (error == nil) {

                for item in response.mapItems {
                    placemarks.addObject((item as MKMapItem).placemark)
                }
                
                self.mapView.showAnnotations(placemarks, animated: true)
            } else {
                println("Error")
            }
        }
        
        // 3
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = "Meet Near Here"
        //placemarks.addObject(annotation)
        //mapView.addAnnotation(annotation)
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
    
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }
    
    func calcAverageLocation() -> CLLocationCoordinate2D {
        
        var totalLat = 0.0
        var totalLon = 0.0
        
        for coord in appDele.coordinates {
            totalLat += Double(coord.latitude)
            totalLon += Double(coord.longitude)
        }
        
        totalLat = totalLat / Double(appDele.coordinates.count)
        totalLon = totalLon / Double(appDele.coordinates.count)
        
        println(totalLat)
        println(totalLon)
        
        return CLLocationCoordinate2D(latitude: totalLat,longitude: totalLon)
    }
}

