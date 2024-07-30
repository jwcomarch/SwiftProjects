//
//  Script.swift
//  Extension
//
//  Created by Jakub Włodarski on 24/07/2024.
//

import UIKit

class Script: NSObject, Codable {
    var title: String
    var js: String
    
    init(title: String, js: String) {
        self.title = title
        self.js = js
    }
}
