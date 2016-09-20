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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //TODO::This should wraped as well -> (get photo details) they could be a struct or something
    var photoSecret:String?
    var photoId:String?
    var photo:UIImage?
    
    override func viewDidLoad() {
    
        self.flickrImageView.image = self.photo

        self.startLoadingAnimation()
        
        FlickrService.getPhotoDetails(id: photoId!, secret: photoSecret!, success: { ( photo:NSDictionary) in
            self.stopLoadingAnimation()
            let description = photo.object(forKey: "description") as! NSDictionary
            let descriptionContent = description.object(forKey: "_content") as! String
            let views = photo.object(forKey: "views") as! String
            let date = photo.object(forKey: "dates") as! NSDictionary
            let dateTaken = date.object(forKey: "taken") as! String
            let title = photo.object(forKey: "title") as! NSDictionary
            let titleContent = title.object(forKey: "_content") as! String
            //TODO::add the location as well from the details.            
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
            
            }) {
                self.stopLoadingAnimation()
                print("Failed to get photo details:(")
        }
        
    }
    
    
    // MARK: - Loading Animation
    
    func startLoadingAnimation(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopLoadingAnimation(){
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
}
