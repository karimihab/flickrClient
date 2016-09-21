//
//  ViewController.swift
//  FlickrClient
//
//  Created by Karim Ihab on 19/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import UIScrollView_InfiniteScroll

class FlickrSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photosList = [SearchResultPhoto]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchPage:Int = 1 // used in pagging results from server
    var searchTimer:Timer? // timer to give user time to type before auto search starts
    var oldSearchString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        AlertUtil.showAlert(title: "Welcome to Flickr Search :) ", message: "Please enter text to search photos", buttonText: "OK", viewController: self)
        
        //Search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        //TableView
        self.tableView.delegate = self;
        self.tableView.addInfiniteScroll { (tableView) -> Void in
            self.searchPage = self.searchPage + 1
            self.searchFlickr(searchText: self.searchController.searchBar.text!,page:self.searchPage)
            tableView.finishInfiniteScroll()
        }
    }
    
    
    //MARK: - Search Controller
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text
        if searchController.isActive &&  searchString != ""  && searchString != self.oldSearchString {
            
            self.oldSearchString = searchString!
            //Empty photosList for the new search
            self.photosList = [SearchResultPhoto]()
            
            //Gives the user time to type (i.e 1sec) before starting the search autoamically
            if self.searchTimer != nil {
                self.searchTimer?.invalidate()
                self.searchTimer = nil
            }
            self.searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(search), userInfo: searchString, repeats: false)
        }
    }
    
    func search(timer:Timer){
        let searchTerm = timer.userInfo as! String
        self.startLoadingAnimation()
        self.searchFlickr(searchText: searchTerm,page:1)
    }
    
    func searchFlickr(searchText:String, page:Int){
        
        if NetworkUtil.isOffline(){
            AlertUtil.showAlert(title: "Oops :(", message: "Please check your internet connection, seems offline!", buttonText: "OK", viewController: self)
            self.stopLoadingAnimation()
            return
        }
        
        FlickrService.searchForText(searchText: searchText, page: page, success: { (photos:[SearchResultPhoto]) in
            self.stopLoadingAnimation()
            
            if photos.count == 0 {
                 AlertUtil.showAlert(title: "Oops :(", message: "No results for your search, please try different words", buttonText: "OK", viewController: self)
                return
            }
            
            if self.photosList.count == 0{
                self.photosList = photos
            }else{
                self.photosList.append(contentsOf: photos)
            }
            self.tableView.reloadData()
            
        }) { (error:String?) in
            self.stopLoadingAnimation()
            if let error = error{
                AlertUtil.showAlert(title: "Oops :(", message: error, buttonText: "OK", viewController: self)
            }
        }
        
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
            cell.flickrImageTitle.text = photo.title
            cell.flickrImageView.sd_setImage(with: URL(string:photo.photoUrl!), placeholderImage: UIImage(named: "placeholder"))
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
                controller.searchResultPhoto = photo
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

