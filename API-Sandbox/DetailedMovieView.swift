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
    
    var detailsMovie : Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let movie = detailsMovie {
            movieLabel.text = movie.name
            movieSummary.text = movie.summary
            print("details movie poster \(moviePoster)")
            //moviePoster.image = movie.movieImage!
            print(movie.movieImage!)
            moviePoster.af_setImageWithURL(NSURL(string: movie.posterURL)!)
            print(movie.movieImage!)
            print("details movie poster \(moviePoster)")
            
        } else {
            movieLabel.text = "Oops!"
            // TODO: How to add a defualt image?
            movieSummary.text = "Something unexpected happened. Please select a different movie."
        }
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
