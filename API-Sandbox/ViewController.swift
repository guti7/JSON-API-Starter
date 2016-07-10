//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var getMovieButton: UIButton!
    
    var randomMovie: Movie! {
        didSet {
            self.movieTitleLabel.text = self.randomMovie.name
            self.rightsOwnerLabel.text = self.randomMovie.rightsOwner
            self.releaseDateLabel.text = self.randomMovie.releaseDate
            self.priceLabel.text = String(self.randomMovie.price)
            loadPoster(randomMovie.posterURL)
            self.randomMovie.movieImage = posterImageView.image
        }
        
    }

    var json: JSON!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        exerciseOne()
//        exerciseTwo()
//        exerciseThree()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    
                    // + instance variable of Movie to this V.C.
                    // Parse Json to grab a random movieJSON
                    // use arc4random_uniform(upperBound) 0 to < upperBound
                    // takes UInt32 cast Int
                    // create a Movie object 
                    // Use Movie object to populate UIViewController
                    
                    self.setUpRandomMovie(self.json)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func setUpRandomMovie(json: JSON) {
        let jsonDataArray = json["feed"]["entry"].arrayValue
        let ranNumUInt32 = arc4random_uniform(UInt32(jsonDataArray.count * 8))
        let ranInt = Int(ranNumUInt32 % 25)
        self.randomMovie = Movie(json: jsonDataArray[ranInt])
        loadPoster(self.randomMovie.posterURL)
        self.randomMovie.movieImage = posterImageView.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImageWithURL(NSURL(string: urlString)!)
        
    }
    
    
    // MARK: Actions
    
    @IBAction func viewOniTunesPressed(sender: AnyObject) {
        print(randomMovie)
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.stackoverflow.com")!)
        UIApplication.sharedApplication().openURL(NSURL(string: randomMovie.link)!)
    }
    
    // called when get another movie button is pressed
    @IBAction func getRandomMovie(sender: UIButton) {
        self.setUpRandomMovie(self.json)
    }
    
    
    // Left empty on purpose
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "displayDetails" {
                
                let displayDetailsController = segue.destinationViewController as! DetailedMovieView
                
                displayDetailsController.detailsMovie = self.randomMovie
                
            }
        }
    }
    
}

