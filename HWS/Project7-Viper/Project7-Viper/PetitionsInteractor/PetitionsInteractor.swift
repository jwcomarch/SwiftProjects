//
//  PetitionsInteractor.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation

protocol PetitionsInteractor: AnyObject {
    func setPetitions(on barTag: Int)
    func fetchPetitions(with filter: String) -> [Petition]
}

class PetitionsInteractorImplementation: PetitionsInteractor {
    var presenter: PetitionsPresenter?
    var repo: PetitionsRepo?
    
    var petitions = [Petition]()
    
    init(presenter: PetitionsPresenter, barTag: Int) {
        self.presenter = presenter
        self.repo = PetitionsRepoImplementation()
        setPetitions(on: barTag)
    }
    
    func setPetitions(on barTag: Int) {
        petitions = repo!.fetchPetitions(from: barTag)!
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
