//
//  Where2MeetTests.swift
//  Where2MeetTests
//
//  Created by Ray Badger on 06/10/2014.
//  Copyright (c) 2014 TKA. All rights reserved.
//

import UIKit
import XCTest

import Where2Meet

class Where2MeetTests: XCTestCase {

    //var app : UIApplication?
    
    var vc : FirstViewController!
    
    override func setUp() {
        super.setUp()
        //app = UIApplication.sharedApplication()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.

        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        vc = storyboard.instantiateViewControllerWithIdentifier("FirstViewController") as FirstViewController
        vc.loadView()
        
//        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
//        let vc:FirstViewController = storyboard.instantiateViewControllerWithIdentifier("FirstViewController") as FirstViewController
//        
//        let dummy = "AnyObject" //vc.view // force loading subviews and setting outlets
//        
//        //vc.viewDidLoad()
//        
        XCTAssertNotNil(vc, "View controller should not be nil")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
