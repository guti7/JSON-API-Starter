//
//  DetailedMovieView.swift
//  API-Sandbox
//
//  Created by Guti on 7/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage



class DetailedMovieView: UIViewController {
    // MARK: Properties
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieSummary: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    var isFromMovie = true
    
    var detailsMovie : Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = detailsMovie {
            movieLabel.text = movie.name
            movieSummary.text = movie.summary
            moviePoster.image = movie.movieImage
            backgroundImageView.image = movie.movieImage
            if isFromMovie {
                backButton.layer.borderColor = UIColor.whiteColor().CGColor
            } else { // all movies
                
                title = movieLabel.text
                backButton.hidden = true
                movieLabel.hidden = true
                //moviePoster.af_setImageWithURL(NSURL(string: movie.posterURL)!)
                
                self.moviePoster.af_setImageWithURL(NSURL(string: movie.posterURL)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: dispatch_get_main_queue(), imageTransition: .None, runImageTransitionIfCached: false) { (response: Response <UIImage, NSError>) in
                    
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            self.backgroundImageView.image = value
                        }
                    case .Failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            // TODO: Add a default image?
            movieLabel.text = "Oops!"
            movieSummary.text = "Something unexpected happened. Please select a different movie."
            moviePoster.image = UIImage(named: "defaultBackgroundImage")
        }
        applyBlurEffect(.Dark)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func applyBlurEffect(effect: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: effect)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        backgroundImageView.addSubview(blurView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
