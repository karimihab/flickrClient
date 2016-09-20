//
//  JsonUtil.swift
//  FlickrClient
//
//  Created by Karim Ihab on 20/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation

//Seprating Json Prasing in a seprate class enables us to change the way to parse Json without affecting our services
//for Example instead of simple Structs we can have json mapped to object classes 
//we can use third party libs (swiftJSON,...etc)

class JsonUtil {
    
    class func parsePhotoObjectJSON(json:NSDictionary) -> FlickrPhoto? {
        
        if let photo = json.object(forKey: "photo") as! NSDictionary?{
            let description = photo.object(forKey: "description") as! NSDictionary
            let descriptionContent = description.object(forKey: "_content") as! String
            let views = photo.object(forKey: "views") as! String
            let date = photo.object(forKey: "dates") as! NSDictionary
            let dateTaken = date.object(forKey: "taken") as! String
            let title = photo.object(forKey: "title") as! NSDictionary
            let titleContent = title.object(forKey: "_content") as! String
            let flickrPhoto = FlickrPhoto(title: titleContent, photoDescription: descriptionContent, dateTaken: dateTaken, views: views)
            return flickrPhoto
        }
        else{
            return nil
        }
        
    }
    
    class func parseSearchResultJSON(json:NSDictionary) -> [SearchResultPhoto]? {
        
        if let photos = json.object(forKey: "photos") as! NSDictionary? {
            let photosList = photos.object(forKey: "photo") as! [NSDictionary]
            var searchResultPhotosArray:[SearchResultPhoto] = [SearchResultPhoto]()
            
            for photo in photosList {
                let title = photo.object(forKey: "title") as! String
                let farmId = photo.object(forKey:"farm")!
                let serverId = photo.object(forKey:"server")!
                let id = photo.object(forKey:"id")!
                let secret = photo.object(forKey:"secret")!
                let photoUrl = URLBuilderUtil.getPhotoURL(farmId: "\(farmId)", serverId: "\(serverId)", id: "\(id)", secret: "\(secret)")
                let searchResultPhoto = SearchResultPhoto(title: title, farmId: "\(farmId)", serverId: "\(serverId)", photoUrl: photoUrl, secret:"\(secret)", id:"\(id)" )
                searchResultPhotosArray.append(searchResultPhoto)
            }
            
            return searchResultPhotosArray
        }else{
            return nil
        }

    }
    
}
