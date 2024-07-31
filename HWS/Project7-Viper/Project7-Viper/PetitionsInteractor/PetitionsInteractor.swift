//
//  PetitionsInteractor.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation

//Interactor
protocol PetitionsInteractor: AnyObject {
    func setPetitions(with filter: String)
    func fetchPetitions(with filter: String) -> [Petition]
}

class PetitionsInteractorImplementation: PetitionsInteractor {
    var presenter: PetitionsPresenter?
    var repo: PetitionsRepo?
    
    var petitions = [Petition]()
    
    init(presenter: PetitionsPresenter) {
        self.presenter = presenter
        self.repo = PetitionsRepoImplementation()
        setPetitions(with: "")
    }
    
    func setPetitions(with filter: String) {
        petitions = repo!.getPetitions(with: filter)
    }
    
    func fetchPetitions(with filter: String) -> [Petition] {
        if filter.isEmpty {
            return petitions
        }
        
        var filteredPetitions = [Petition]()
        for petition in petitions {
            if petition.title.contains(filter) || petition.body.contains(filter) {
                filteredPetitions.append(petition)
            }
        }
        return filteredPetitions
    }
}
