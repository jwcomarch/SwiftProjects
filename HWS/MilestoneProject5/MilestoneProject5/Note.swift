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
    var editDate: String
    
    init(title: String, content: String, editDate: String) {
        self.title = title
        self.content = content
        self.editDate = editDate
    }
    
    init(title: String, editDate: String) {
        self.title = title
        self.content = ""
        self.editDate = editDate
    }
}
