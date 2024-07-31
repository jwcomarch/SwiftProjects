//
//  PetitionsRepo.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation

protocol PetitionsRepo: AnyObject {
    func getPetitions(with filter: String) -> [Petition]
    func fetchPetitions() -> [Petition]?
}

class PetitionsRepoImplementation: PetitionsRepo {
    
    private let urlString: [String] = [
        "https://www.hackingwithswift.com/samples/petitions-1.json",
        "https://www.hackingwithswift.com/samples/petitions-2.json"
    ]
    
    func getPetitions(with filter: String) -> [Petition] {
        let petitions = fetchPetitions()!
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
    
    func fetchPetitions() -> [Petition]? {
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                if let petitions = parse(json: data) {
                    return petitions
                }
            }
        }
        return nil
    }
    
    func parse(json: Data) -> [Petition]? {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            let petitions = jsonPetitions.results
            return petitions
        }
        return nil
    }
}
