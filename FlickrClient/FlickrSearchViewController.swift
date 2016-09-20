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
import UIScrollView_InfiniteScroll

class FlickrSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photosList = [NSDictionary]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchPage:Int = 1 // used in pagging results
    var searchTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        //Search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        //TableView
        self.tableView.delegate = self;
        
        self.tableView.addInfiniteScroll { (tableView) -> Void in
            
            self.searchPage = self.searchPage + 1
            self.searchFlickr(tag: self.searchController.searchBar.text!, page: self.searchPage)

            tableView.finishInfiniteScroll()
        }
    }
    
    func searchFlickr(tag:String, page:Int) {
        
//        print("Tag:\(tag) & page:\(page)")
        let apiKey = "0f911b777e2e4a198a2ee4e6e4ea1fdd"
//        let tags = tag
        let text = tag
        let baseURL = "https://api.flickr.com/services/rest/?&method=flickr.photos.search"
        let apiString = "&api_key=\(apiKey)"
//        let searchString = "&tags=\(tags)"
        let searchTextString = "&text=\(text)"
        let encodedsearchText = searchTextString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let responseFormat = "&format=json"
        let jsonCallbackString = "&nojsoncallback=1"
        let pageString = "&page=\(page)"
        
        let searchUrl = baseURL + apiString + encodedsearchText + responseFormat + pageString + jsonCallbackString
        self.startLoadingAnimation()
        print("================>:\(searchUrl)")
        Alamofire.request(searchUrl).responseJSON { response in
            print("=======:Erro:\(response.result.error?.localizedDescription)")
            self.stopLoadingAnimation()
            if let result = response.result.value {
                let jsonResult = result as! NSDictionary
                print("jsonResult:::::::\(jsonResult)")
                let photosResultObject = jsonResult.object(forKey: "photos") as! NSDictionary
                let photosList = photosResultObject.object(forKey: "photo") as! [NSDictionary]
                
                if self.photosList.count == 0{
                    self.photosList = photosList
                }else{
                    self.photosList.append(contentsOf: photosList)
                }
                
                self.tableView.reloadData()
                self.tableView.finishInfiniteScroll()
            }
            
        }
    }
    
    //MARK: - Search Controller
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text
        if searchController.isActive &&  searchString != "" {
            
            //Empty photosList
            self.photosList = [NSDictionary]()

            //Gives the user time to type (i.e 2sec) before starting the search
            if self.searchTimer != nil {
                self.searchTimer?.invalidate()
                self.searchTimer = nil
            }
            self.searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(search), userInfo: searchString, repeats: false)
        }
        
    }
    
    func search(timer:Timer){
        let tag = timer.userInfo as! String
        self.searchFlickr(tag: tag, page: 1)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
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

