//
//  Picture.swift
//  MilestoneProject4
//
//  Created by Jakub Włodarski on 23/07/2024.
//

import UIKit

class Picture: NSObject, Codable {
    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
