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
    static func searchForText(searchText:String, page:Int, success: @escaping ([NSDictionary]) -> Void , failure: @escaping () -> Void) {
        
        Alamofire.request(URLBuilderUtil.getSearchURL(searchTerm:searchText,page:page)).responseJSON { response in
            
            if let result = response.result.value {
                let jsonResult = result as! NSDictionary
                if let photosResultObject = jsonResult.object(forKey: "photos") as! NSDictionary? {
                    let photosList = photosResultObject.object(forKey: "photo") as! [NSDictionary]
                    success(photosList)
                }
                else{
                    failure()
                }
            }else{
                failure()
            }
        }
        
    }
    
    //Get Photo details
    static func getPhotoDetails(id:String, secret:String, success: @escaping (NSDictionary) -> Void , failure: @escaping () -> Void) {
        
        Alamofire.request(URLBuilderUtil.getPhotoDetailsURL(photoId:id, photoSecret:secret)).responseJSON { response in
            
            if let result = response.result.value {
                let jsonResult = result as! NSDictionary
                if let photo = jsonResult.object(forKey: "photo") as! NSDictionary?{
                    success(photo)
                }else{
                    failure()
                }
            }else{
                failure()
            }
        }
        
    }
}




