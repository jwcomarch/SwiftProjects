//
//  PetitionsBuilder.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation
import UIKit

final class PetitionsBuilder {
    func build() -> UITableViewController {
        let router = PetitionsRouterImplementation()
        let repo = PetitionsRepoImplementation()
        let interactor = PetitionsInteractor(repo: repo)
        let presenter = PetitionsPresenterImplementation(router: router, interactor: interactor)
        let view = PetitionsViewController(presenter: presenter)
        
        router.viewController = view
        interactor.output = presenter
        return view
    }
}
