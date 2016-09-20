//
//  ViewController.swift
//  FlickrClient
//
//  Created by Karim Ihab on 19/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import UIKit
import  Alamofire
import SDWebImage

class FlickrSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var photosList = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self;        
        let apiKey = "0f911b777e2e4a198a2ee4e6e4ea1fdd"
        let tags = "Egypt"
//        let text = "egypt pyramids"
        let baseURL = "https://api.flickr.com/services/rest/?&method=flickr.photos.search"
        let apiString = "&api_key=\(apiKey)"
        let searchString = "&tags=\(tags)"
//        let searchTextString = "&text=\(text)"
        let responseFormat = "&format=json"
        let jsonCallbackString = "&nojsoncallback=1"
        
        
        
        Alamofire.request(baseURL + apiString + searchString + responseFormat + jsonCallbackString).responseJSON { response in
            
            print("---------------------------------------------------------------")
//            print("original URL request : \(response.request)")
//            print("---------------------------------------------------------------")
//            print("HTTP URL response : \(response.response)")
//            print("---------------------------------------------------------------")
//            print("server data : \(response.data)")
//            print("---------------------------------------------------------------")
//            print("result of response serialization : \(response.result)")
//            print("---------------------------------------------------------------")
//
////            if let data = data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)")
//            }
            if let result = response.result.value {
                let jsonResult = result as! NSDictionary
                let photosResultObject = jsonResult.object(forKey: "photos") as! NSDictionary
                let photosList = photosResultObject.object(forKey: "photo") as! [NSDictionary]
//                var photos:[String]
                self.photosList = photosList
                print("self.photosList:::::::\(self.photosList)")
                self.tableView.reloadData()
//                print(photosList.firstObject)
                print("---------------------------------------------------------------")
            }
            
        }
        
    }
    
    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath) as! FlickrTableViewCell
        
        let photo = self.photosList[indexPath.row]
        cell.flickrImageTitle.text = photo.object(forKey: "title") as! String?
        let farmId = photo.object(forKey:"farm")!
        let serverId = photo.object(forKey:"server")!
        let id = photo.object(forKey:"id")!
        let secret = photo.object(forKey:"secret")!
        let photoUrl = "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret).jpg"
        print("photoUrl::::::::\(photoUrl)")
        
        cell.flickrImageView.sd_setImage(with: URL(string:photoUrl), placeholderImage: UIImage(named: "placeholder"))

        return cell
    }
    
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let photo = photosList[indexPath.row]
                let controller = segue.destination as! FlickrPhotoDetailsViewController
                controller.photoId = photo.object(forKey: "id") as? String
                controller.photoSecret = photo.object(forKey: "secret") as? String
                
            }
        }
    }
    
}

