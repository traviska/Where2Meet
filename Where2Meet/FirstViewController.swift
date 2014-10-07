//
//  FirstViewController.swift
//  Where2Meet
//
//  Created by Ray Badger on 06/10/2014.
//  Copyright (c) 2014 TKA. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let appDele = UIApplication.sharedApplication().delegate as AppDelegate
    
    @IBOutlet var postcodeField: UITextField!
    @IBOutlet var locationList: UITableView!
    
    @IBOutlet var addButton: UIButton!
    
    @IBAction func addLocation(sender: UIButton) {
        if (!postcodeField.text.isEmpty) {
            appDele.postcodes.append(postcodeField.text)
            self.locationList.reloadData()
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
        
        cell.textLabel?.text = appDele.postcodes[indexPath.row]
        return cell
    }


}

