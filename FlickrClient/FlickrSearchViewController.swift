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

class FlickrSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {
    
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            filterContentForSearchText(searchText: searchController.searchBar.text!)
        }
        
    }

    
    @IBOutlet weak var tableView: UITableView!
    var photosList = [NSDictionary]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        
        //TableView
        self.tableView.delegate = self;
        
        //API
//        self.searchFlickr(tag:"Cairo")
        
    }
    
    func searchFlickr(tag:String) {
        let apiKey = "0f911b777e2e4a198a2ee4e6e4ea1fdd"
        let tags = tag
//        let text = tag
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
    
    //MARK: - Search Controller
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        self.searchFlickr(tag: searchText)
    }
    
    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return photosList.count
        }
        return 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath) as! FlickrTableViewCell
        if searchController.isActive && searchController.searchBar.text != "" {
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
        } else {
            return cell
        }
//                
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath) as! FlickrTableViewCell
//        
//        let photo = self.photosList[indexPath.row]
//        cell.flickrImageTitle.text = photo.object(forKey: "title") as! String?
//        let farmId = photo.object(forKey:"farm")!
//        let serverId = photo.object(forKey:"server")!
//        let id = photo.object(forKey:"id")!
//        let secret = photo.object(forKey:"secret")!
//        let photoUrl = "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret).jpg"
//        print("photoUrl::::::::\(photoUrl)")
//        
//        cell.flickrImageView.sd_setImage(with: URL(string:photoUrl), placeholderImage: UIImage(named: "placeholder"))
//
//        return cell
    }
    
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let photo = photosList[indexPath.row]
                let controller = segue.destination as! FlickrPhotoDetailsViewController
                controller.photoId = photo.object(forKey: "id") as? String
                controller.photoSecret = photo.object(forKey: "secret") as? String
                let cell = self.tableView.cellForRow(at: indexPath) as! FlickrTableViewCell
                controller.photo = cell.flickrImageView.image
            }
        }
    }
    
}

