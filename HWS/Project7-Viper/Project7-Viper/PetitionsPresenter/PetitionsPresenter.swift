//
//  PetitionsPresenter.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation
import UIKit

protocol PetitionsPresenter: AnyObject {
    func setPetitions(with filter: String)
    func showDetails(petition: Petition)
    func sendPetitions(petitions: [Petition])
}

class PetitionsPresenterImplementation: PetitionsPresenter {
    
    var view: PetitionsView?
    var router: PetitionsRouter?
    var interactor: PetitionsInteractor?
    
    init(view: PetitionsView, barTag: Int) {
        self.view = view
        self.router = PetitionsRouterImplementation()
        self.interactor = PetitionsInteractorImplementation(presenter: self, barTag: barTag)
    }
    
    func setPetitions(with filter: String) {
        view!.setPetitions(petitionsList: interactor!.fetchPetitions(with: filter))
    }
    
    func sendPetitions(petitions: [Petition]) {
        view!.setPetitions(petitionsList: petitions)
    }
    
    func showDetails(petition: Petition) {
        router?.presentDetails(parentViewController: view! as! UIViewController, petition: petition)
    }
}
