//
//  FlickrServiceTests.swift
//  FlickrClient
//
//  Created by Karim Ihab on 21/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import XCTest
@testable import FlickrClient

class FlickrServiceTests: XCTestCase {
        
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    //Asynchronus Test
    func testGettingSearchResults(){
        
        let searchExpectation = expectation(description: "search result test")
        
        FlickrService.searchForPhotos(searchText: "cats and dogs", page: 1, success: { (photos:[SearchResultPhoto]) in
            
            XCTAssertNotNil(photos, "data should not be nil")
            XCTAssertGreaterThan(photos.count, 0, "No search results")
            
            searchExpectation.fulfill()
            
        }) { (error:String?) in
             searchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 4)
    }
    
    func testGettingPhotoDetails(){
        
        let getPhotoExpectation = expectation(description: "get photo details test")
        
        FlickrService.getPhotoDetails(id: "29801363815", secret: "149801ee64", success: { (photo:FlickrPhoto) in
            
            XCTAssertNotNil(photo, "data should not be nil")
            getPhotoExpectation.fulfill()
            
        }) { (error:String?) in
                getPhotoExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
}
