//
//  DetailsRouter.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 01/08/2024.
//

import Foundation
import UIKit

protocol DetailsRouter {
    
}

class DetailsRouterImplementation: DetailsRouter {
    var presenter: DetailsPresenter?
    
    init(presenter: DetailsPresenter) {
        self.presenter = presenter
    }
}
