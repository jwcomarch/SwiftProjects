//
//  DetailsPresenter.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 01/08/2024.
//

import Foundation
import UIKit

protocol DetailsPresenter {
    
}

class DetailsPresenterImplementation: DetailsPresenter {
    var view: DetailsView?
    var router: DetailsRouter?
    var interactor: DetailsInteractor?
    
    init(view: DetailsView) {
        self.view = view
        self.router = DetailsRouterImplementation(presenter: self)
        self.interactor = DetailsInteractorImplementation(presenter: self)
    }
}
