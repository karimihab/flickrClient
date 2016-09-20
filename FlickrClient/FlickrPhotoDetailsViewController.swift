//
//  FlickrPhotoDetailsViewController.swift
//  FlickrClient
//
//  Created by Karim Ihab on 20/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import UIKit
import Alamofire

class FlickrPhotoDetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var flickrPhotoDescriptionLabel: UILabel!
    @IBOutlet weak var flickerImageView: UIImageView!
    
    //This should wraped as well -> (get photo details) they could be a struct or something
    var photoSecret:String?
    var photoId:String?
    
    override func viewDidLoad() {
    
        let apiKey = "0f911b777e2e4a198a2ee4e6e4ea1fdd"
        let baseURL = "https://api.flickr.com/services/rest/?&method=flickr.photos.getinfo"
        let responseFormat = "&format=json"
        let jsonCallbackString = "&nojsoncallback=1"
        let apiString = "&api_key=\(apiKey)"
        let secretString = "&secret=\(self.photoSecret!)"
        let photoIdString = "&photo_id=\(self.photoId!)"
        
        let url:String = baseURL + apiString + secretString + photoIdString + responseFormat + jsonCallbackString
        print("URL:\(url)")
        Alamofire.request(url).responseJSON { response in

            
            print("---------------------------------------------------------------")
            print("original URL request : \(response.request)")
            print("---------------------------------------------------------------")
            print("HTTP URL response : \(response.response)")
            print("---------------------------------------------------------------")
            print("server data : \(response.data)")
            print("---------------------------------------------------------------")
            print("result of response serialization : \(response.result)")
            print("---------------------------------------------------------------")
            
            if let result = response.result.value {
                let jsonResult = result as! NSDictionary
                let photo = jsonResult.object(forKey: "photo") as! NSDictionary
                let description = photo.object(forKey: "description") as! NSDictionary
                let descriptionContent = description.object(forKey: "_content") as! String
                self.flickrPhotoDescriptionLabel.text = descriptionContent
            }
            
        }
        
    }
}
