//
//  Note.swift
//  MilestoneProject5
//
//  Created by Jakub Włodarski on 25/07/2024.
//

import UIKit

class Note: NSObject, Codable {
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    init(title: String) {
        self.title = title
        self.content = ""
    }
}
