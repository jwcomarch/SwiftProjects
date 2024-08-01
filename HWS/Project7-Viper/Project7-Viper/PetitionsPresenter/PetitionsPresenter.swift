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
}

class PetitionsPresenterImplementation: PetitionsPresenter {
    var view: PetitionsView?
    var router: PetitionsRouter?
    var interactor: PetitionsInteractor?
    
    var petitions = [Petition]()
    
    init(view: PetitionsView, barTag: Int) {
        self.view = view
        self.router = PetitionsRouterImplementation()
        self.interactor = PetitionsInteractorImplementation(presenter: self, barTag: barTag)
        setPetitions(with: "")
        print("Presenter Init bartag: \(barTag)")
    }
    
    func setPetitions(with filter: String) {
        petitions = interactor!.fetchPetitions(with: filter)
        view!.setPetitions(petitionsList: petitions)
    }
    
    func showDetails(petition: Petition) {
        router?.presentDetails(parentViewController: view! as! UIViewController, petition: petition)
    }
}
