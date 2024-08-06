//
//  User.swift
//  Appetizers
//
//  Created by Jakub Włodarski on 06/08/2024.
//

import Foundation

struct User: Codable {
    var firstName = ""
    var lastName = ""
    var email = ""
    var birthdate = Date()
    var extraNapkins = false
    var frequentRefills = false
}
