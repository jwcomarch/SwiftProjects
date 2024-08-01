//
//  PetitionsPresenter.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation
import UIKit

//Presenter
protocol PetitionsPresenter: AnyObject {
    func setPetitions(with filter: String)
    func showDetails(petition: Petition)
}

class PetitionsPresenterImplementation: PetitionsPresenter {
    
    var view: PetitionsView?
    var router: PetitionsRouter?
    var interactor: PetitionsInteractor?
    
    var petitions = [Petition]()
    
    init(view: PetitionsView) {
        self.view = view
        self.router = PetitionsRouterImplementation()
        self.interactor = PetitionsInteractorImplementation(presenter: self)
        setPetitions(with: "")
    }
    
    func setPetitions(with filter: String) {
        petitions = interactor!.fetchPetitions(with: filter)
        view!.setPetitions(petitionsList: petitions)
    }
    
    func showDetails(petition: Petition) {
        router?.presentDetails(parentViewController: view! as! UIViewController, petition: petition)
    }
}
