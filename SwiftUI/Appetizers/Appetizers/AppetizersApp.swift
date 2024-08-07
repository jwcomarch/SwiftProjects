//
//  AppetizersApp.swift
//  Appetizers
//
//  Created by Jakub Włodarski on 05/08/2024.
//

import SwiftUI

@main
struct AppetizersApp: App {
    
    var order = Order()
    
    var body: some Scene {
        WindowGroup {
            AppetizerTabView().environmentObject(order)
        }
    }
}
