//
//  AllMoviesViewController.swift
//  API-Sandbox
//
//  Created by Guti on 8/2/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class AllMoviesViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredMovies = [Movie]()
    var allMoviesData = [Movie]()
    
    let segueDetailsFromMovies = "deatailsFromAllMovies"
    
    var json : JSON!
    var jsonDataArray = [JSON]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
       // self.jsonDataArray = [JSON]()// [] //Array() // Array<JSON>()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.json = JSON(value)
                    self.jsonDataArray = self.json["feed"]["entry"].arrayValue
                    self.getAllMoviesFromJson()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            case .Failure(let error):
                print(error)
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Helper method to filter Movies
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredMovies = allMoviesData.filter { movie in
            return movie.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    func getAllMoviesFromJson() {
        for json in jsonDataArray {
            allMoviesData.append(Movie(json: json))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active && searchController.searchBar.text != "" {
            return filteredMovies.count
        }
        return self.jsonDataArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let movie: Movie
        if searchController.active && searchController.searchBar.text != "" {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = self.allMoviesData[indexPath.row]
        }
            
        cell.textLabel?.text = movie.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier(segueDetailsFromMovies, sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == segueDetailsFromMovies {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let movie: Movie
                if searchController.active && searchController.searchBar.text != "" {
                    movie = filteredMovies[indexPath.row]
                } else {
                    movie = allMoviesData[indexPath.row]
                }
                let destinationController = segue.destinationViewController as! DetailedMovieView
                
                destinationController.detailsMovie  = movie
                destinationController.isFromMovie = false
            }
        }
    }
}

extension AllMoviesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

/*
 // Override to support conditional editing of the table view.
 override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
 if editingStyle == .Delete {
 // Delete the row from the data source
 tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
 } else if editingStyle == .Insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */