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
    @IBOutlet weak var backgroundView: UIImageView!

    @IBOutlet weak var buttonViewOnItunes: UIButton!
    @IBOutlet weak var getMovieButton: UIButton!
    
    var randomMovie: Movie! {
        didSet {
            self.movieTitleLabel.text = self.randomMovie.name
            self.rightsOwnerLabel.text = self.randomMovie.rightsOwner
            self.releaseDateLabel.text = self.randomMovie.releaseDate
            self.priceLabel.text = String("$\(self.randomMovie.price)")
        }
        
    }

    var json: JSON!
    var jsonDataArray: [JSON]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getMovieButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        buttonViewOnItunes.layer.borderColor = UIColor.whiteColor().CGColor
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=100/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.json = JSON(value)
                    self.jsonDataArray = self.json["feed"]["entry"].arrayValue
                
                    self.setUpRandomMovie()

                }
            case .Failure(let error):
                print(error)
            }
        }
        
        applyBlurEffect(.Dark)
    }
    
    private func setUpRandomMovie() {
        //jsonDataArray = json["feed"]["entry"].arrayValue
        let ranNumUInt32 = arc4random_uniform(UInt32(jsonDataArray.count * 8))
        let ranInt = Int(ranNumUInt32 % 100)
        self.randomMovie = Movie(json: jsonDataArray[ranInt])
        loadPoster(randomMovie.posterURL)
    }
    
    private func applyBlurEffect(effect: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: effect)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        backgroundView.addSubview(blurView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: dispatch_get_main_queue(), imageTransition: .None, runImageTransitionIfCached: false) { (response: Response<UIImage, NSError>) in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.backgroundView.image = value
                    self.randomMovie.movieImage = value
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func viewOniTunesPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: randomMovie.link)!)
    }
    
    // called when get another movie button is pressed
    @IBAction func getRandomMovie(sender: UIButton) {
        self.setUpRandomMovie()
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

