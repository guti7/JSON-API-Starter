//
//  Movie.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Movie {
    let name: String
    let summary: String
    let rightsOwner: String
    let price: Double
    let link: String
    let releaseDate: String
    var posterURL: String!
    var movieImage: UIImage!
    
    
    init(json: JSON) {
        self.name = json["im:name"]["label"].stringValue
        self.summary = json["summary"]["label"].stringValue
        self.rightsOwner = json["rights"]["label"].stringValue == "" ? "N/A" : json["rights"]["label"].stringValue
        self.price = Double(json["im:price"]["attributes"]["amount"].stringValue)!
        self.link = json["link"][0]["attributes"]["href"].stringValue
        self.releaseDate = json["im:releaseDate"]["attributes"]["label"].stringValue
        self.posterURL = setHighResPosterURL(json["im:image"][2]["label"].stringValue)
    }
    
    private func setHighResPosterURL(url: String) -> String{
        return url.stringByReplacingOccurrencesOfString("170x170", withString: "600x600")
    }
}
