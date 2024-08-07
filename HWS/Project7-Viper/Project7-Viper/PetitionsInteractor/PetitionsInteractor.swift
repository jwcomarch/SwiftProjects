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
    func sendPetitions(petitions: [Petition])
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
        repo!.fetchPetitions(from: barTag) { result in
            if let petitions = result {
                self.petitions = petitions
                self.sendPetitions(petitions: petitions)
            } else {
                print("Fetch failure")
            }
        }
    }
    
    func sendPetitions(petitions: [Petition]) {
        self.presenter!.sendPetitions(petitions: petitions)
    }
    
    func fetchPetitions(with filter: String) -> [Petition] {
        if filter.isEmpty {
            return petitions
        }
        
        var filteredPetitions = [Petition]()
        for petition in self.petitions {
            if petition.title.contains(filter) || petition.body.contains(filter) {
                filteredPetitions.append(petition)
            }
        }
        return filteredPetitions
    }
}
