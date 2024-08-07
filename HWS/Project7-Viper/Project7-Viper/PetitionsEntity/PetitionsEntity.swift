//
//  PetitionsEntity.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
