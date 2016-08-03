//
//  DetailedMovieView.swift
//  API-Sandbox
//
//  Created by Guti on 7/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit



class DetailedMovieView: UIViewController {
    // MARK: Properties
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieSummary: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    var showButton = true
    
    var detailsMovie : Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = detailsMovie {
            movieLabel.text = movie.name
            movieSummary.text = movie.summary
            moviePoster.image = movie.movieImage
            //self.moviePoster.af_setImageWithURL(NSURL(string: movie.posterURL)!)
            
        } else {
            // TODO: Add a default image?
            movieLabel.text = "Oops!"
            movieSummary.text = "Something unexpected happened. Please select a different movie."
        }
        
        if showButton {
            backButton.layer.borderColor = UIColor.whiteColor().CGColor
        } else {
            backButton.hidden = true
        }
        backgroundImageView.image = moviePoster.image
        applyBlurEffect(.Dark)
        // Do any additional setup after loading the view.
        
        //self.view.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
