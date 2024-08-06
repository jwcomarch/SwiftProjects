//
//  Alert.swift
//  Appetizers
//
//  Created by Jakub Włodarski on 05/08/2024.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    //MARK: - Network Alerts
    static let invalidData = AlertItem(title: Text("Server Error"),
                                       message: Text("Data received from the server was invalid."),
                                       dismissButton: .default(Text("OK")))
    
    static let invalidResponse = AlertItem(title: Text("Server Error"),
                                           message: Text("Invalid response from the server."),
                                           dismissButton: .default(Text("OK")))
    
    static let invalidURL = AlertItem(title: Text("Server Error"),
                                      message: Text("There was an issure connecting to the server."),
                                      dismissButton: .default(Text("OK")))
    
    static let unableToComplete = AlertItem(title: Text("Server Error"),
                                            message: Text("Unable to complete your request at this time. Please check your connection."),
                                            dismissButton: .default(Text("OK")))
    
    //MARK: - Account Alerts
    static let formEmptyField = AlertItem(title: Text("Empty Field"),
                                            message: Text("You cannot leave any fields empty."),
                                            dismissButton: .default(Text("OK")))
    
    static let formInvalidEmail = AlertItem(title: Text("Invalid Email"),
                                            message: Text("Provided email address is not valid."),
                                            dismissButton: .default(Text("OK")))
    
    static let userSaveSuccess = AlertItem(title: Text("Profile Saved"),
                                             message: Text("Your profile info was successfully saved."),
                                             dismissButton: .default(Text("OK")))
    
    static let invalidUserData = AlertItem(title: Text("Profile Error"),
                                             message: Text("There was an error saving or retrieving your profile."),
                                             dismissButton: .default(Text("OK")))
}
