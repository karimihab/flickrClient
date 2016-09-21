//
//  FlickrService.swift
//  FlickrClient
//
//  Created by Karim Ihab on 20/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Alamofire

//This class acts a service layer responsible for all the flickr related service
//The controller only calls this service for any flicker related tasks
//This will help later if we added a local DB, the controller doens't have to deal with any more classes other than this service class
class FlickrService {
    
    
    //Search for photos
    static func searchForText(searchText:String, page:Int, success: @escaping ([SearchResultPhoto]) -> Void , failure: @escaping (String?) -> Void) {
        Alamofire.request(URLBuilderUtil.getSearchURL(searchTerm:searchText,page:page)).responseJSON { response in
            
            if let result = response.result.value {
                let jsonResult = result as! NSDictionary
                if let photosList = JsonUtil.parseSearchResultJSON(json: jsonResult) {
                    success(photosList)
                }
                else{
                    failure(response.result.error?.localizedDescription)
                }
            }else{
                failure(response.result.error?.localizedDescription)
            }
        }
        
    }
    
    //Get Photo details
    static func getPhotoDetails(id:String, secret:String, success: @escaping (FlickrPhoto) -> Void , failure: @escaping (String?) -> Void) {
        
        Alamofire.request(URLBuilderUtil.getPhotoDetailsURL(photoId:id, photoSecret:secret)).responseJSON { response in
            
            if let result = response.result.value {
                let jsonResult = result as! NSDictionary
                if let flickrPhoto = JsonUtil.parsePhotoObjectJSON(json: jsonResult){
                    success(flickrPhoto)
                }else{
                    failure(response.result.error?.localizedDescription)
                }
            }else{
                failure(response.result.error?.localizedDescription)
            }
        }
        
    }
}




