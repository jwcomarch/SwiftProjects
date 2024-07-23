//
//  Person.swift
//  Project10
//
//  Created by Jakub Włodarski on 19/07/2024.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
