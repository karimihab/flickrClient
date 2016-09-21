//
//  FlickrSearchViewControllerTests.swift
//  FlickrClient
//
//  Created by Karim Ihab on 21/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import XCTest
@testable import FlickrClient

class FlickrSearchViewControllerTests: XCTestCase {
    
    var viewController:FlickrSearchViewController!
    var vc:JsonUtil!
    
    override func setUp() {
        super.setUp()
        
//        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FlickrSearchViewController") as! FlickrSearchViewController
        
        viewController = FlickrSearchViewController()

    }
    override func tearDown() {
        super.tearDown()
    }

    
    
}
