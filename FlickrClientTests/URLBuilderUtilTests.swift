//
//  URLBuilderUtilTests.swift
//  FlickrClient
//
//  Created by Karim Ihab on 21/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import XCTest
@testable import FlickrClient

class URLBuilderUtilTests: XCTestCase {
        
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetSearchURL() {
        let searchTerm = "cats and dogs"
        let page = 5
        
        let searchTextString = "&text=\(searchTerm)"
        let encodedsearchText = searchTextString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let responseFormat = "&format=json"
        let jsonCallbackString = "&nojsoncallback=1"
        let pageString = "&page=\(page)"
        
        let expectedSearchURL = URLBuilderUtil.searchBaseUrl + URLBuilderUtil.apiString + encodedsearchText + responseFormat + pageString + jsonCallbackString
        let searchURL = URLBuilderUtil.getSearchURL(searchTerm: searchTerm, page: page)
        
        XCTAssertEqual(expectedSearchURL,searchURL,"The search Url didn't match the expected one")
        
    }
    
    func testGetPhotoDetailsURL(){
        let photoId = "123"
        let photoSecret = "456"
        
        let responseFormat = "&format=json"
        let jsonCallbackString = "&nojsoncallback=1"
        let secretString = "&secret=\(photoSecret)"
        let photoIdString = "&photo_id=\(photoId)"
        
        let expectedPhotoDetailsUrl = URLBuilderUtil.photoDetailsBaseUrl + URLBuilderUtil.apiString + secretString + photoIdString + responseFormat + jsonCallbackString
        let photoDetailsUrl = URLBuilderUtil.getPhotoDetailsURL(photoId: photoId, photoSecret: photoSecret)
        
        XCTAssertEqual(expectedPhotoDetailsUrl, photoDetailsUrl, "The photo details Url didn't match the expected one")
        
        
    }
    
    func testGetPhotoURL() {
        let farmId = "123"
        let serverId = "456"
        let id = "789"
        let secret = "101112"
        
        let expectedPhotoUrl = "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret).jpg"
        let photoUrl = URLBuilderUtil.getPhotoURL(farmId: farmId, serverId: serverId, id: id, secret: secret)
        
        XCTAssertEqual(expectedPhotoUrl, photoUrl, "The photo URL doesn't match the expected one")        
    }
    
        

    
}
