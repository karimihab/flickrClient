//
//  FlickrPhotoDetailsViewController.swift
//  FlickrClient
//
//  Created by Karim Ihab on 20/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class FlickrPhotoDetailsViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var flickrImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searchResultPhoto:SearchResultPhoto!
    var photo:UIImage?
    
    override func viewDidLoad() {
        
        self.loadImageData();
    }
    
    
    func loadImageData(){
        
        if NetworkUtil.isOffline(){
            AlertUtil.showAlert(title: "Oops :(", message: "Please check your internet connection, seems offline!", buttonText: "OK", viewController: self)
            self.stopLoadingAnimation()
            return
        }

        self.startLoadingAnimation()
        
        //Image
        self.flickrImageView.sd_setImage(with: URL(string:self.searchResultPhoto.photoUrl!), placeholderImage: UIImage(named: "placeholder"))
        
        //Details
        FlickrService.getPhotoDetails(id:"\(searchResultPhoto.id!)", secret:"\(searchResultPhoto.secret!)", success: { ( photo:FlickrPhoto) in
            self.stopLoadingAnimation()
            
            if let description = photo.photoDescription {
                self.descriptionLabel.text = description
            }
            if let views = photo.views {
                self.viewsLabel.text = views
            }
            if let dateTaken = photo.dateTaken {
                self.dateLabel.text = dateTaken
            }
            if let title = photo.title {
                self.titleLabel.text = title
            }
            
        }) { (error:String?) in
            self.stopLoadingAnimation()
            print("Failed to get photo details:(")
            if let error = error{
                AlertUtil.showAlert(title: "Oops :(", message: error, buttonText: "OK", viewController: self)
            }
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
