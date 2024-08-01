//
//  DetailsInteractor.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 01/08/2024.
//

import Foundation
import UIKit

protocol DetailsInteractor {
    
}

class DetailsInteractorImplementation: DetailsInteractor {
    var presenter: DetailsPresenter?
    
    init(presenter: DetailsPresenter) {
        self.presenter = presenter
    }
}
