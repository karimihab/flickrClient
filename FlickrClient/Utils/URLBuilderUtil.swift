//
//  URLBuilderUtil.swift
//  FlickrClient
//
//  Created by Karim Ihab on 20/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation

//This class is responsible for building all the Flickr related URLs for the services
//The sepration also allows us to easly change URLs without affecting the service calls.
class URLBuilderUtil {
    
    private static let flickrBaseUrl = "https://api.flickr.com/services/rest/?"
    static let searchBaseUrl = "\(flickrBaseUrl)&method=flickr.photos.search"
    static let photoDetailsBaseUrl = "\(flickrBaseUrl)&method=flickr.photos.getinfo"
    static let apiString = "&api_key=\(Constants.apiKey)"
    
    class func getSearchURL(searchTerm:String, page:Int, nojsoncallback:Int = 1, format:String = "json") -> String{
        
        let searchTextString = "&text=\(searchTerm)"
        let encodedsearchText = searchTextString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let responseFormat = "&format=\(format)"
        let jsonCallbackString = "&nojsoncallback=\(nojsoncallback)"
        let pageString = "&page=\(page)"
        
        let searchUrl = searchBaseUrl + apiString + encodedsearchText + responseFormat + pageString + jsonCallbackString
        return searchUrl
    }
    
    class func getPhotoDetailsURL(photoId:String, photoSecret:String, nojsoncallback:Int = 1, format:String = "json") -> String {
        
        let responseFormat = "&format=\(format)"
        let jsonCallbackString = "&nojsoncallback=\(nojsoncallback)"
        let secretString = "&secret=\(photoSecret)"
        let photoIdString = "&photo_id=\(photoId)"
        
        let photoDetailsUrl:String = photoDetailsBaseUrl + apiString + secretString + photoIdString + responseFormat + jsonCallbackString
        return photoDetailsUrl
    }
    
    class func getPhotoURL(farmId:String, serverId:String, id:String, secret:String ) -> String {
        
        return "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret).jpg"
    }
}


