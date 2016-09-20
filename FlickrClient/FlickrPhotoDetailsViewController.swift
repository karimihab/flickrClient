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
    
    
    //Outlets
    @IBOutlet weak var flickrImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    //This should wraped as well -> (get photo details) they could be a struct or something
    var photoSecret:String?
    var photoId:String?
    var photo:UIImage?
    
    override func viewDidLoad() {
    
        self.flickrImageView.image = self.photo
        
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
                let views = photo.object(forKey: "views") as! String
                let date = photo.object(forKey: "dates") as! NSDictionary
                let dateTaken = date.object(forKey: "taken") as! String
                let title = photo.object(forKey: "title") as! NSDictionary
                let titleContent = title.object(forKey: "_content") as! String

//                Location 7lwa
                
                if descriptionContent != "" {
                        self.descriptionLabel.text = "Description: \(descriptionContent)"
                }
                if views != "" {
                    self.viewsLabel.text = "Views: \(views)"
                }
                if dateTaken != "" {
                    self.dateLabel.text = "Date Taken: \(dateTaken)"
                }
                if titleContent != "" {
                    self.titleLabel.text = titleContent
                }
                
            }
            
        }
        
    }
}
