//
//  PetitionsRepo.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation

final class PetitionsRepoImplementation: PetitionsRepo {
    func fetchPetitions(completion: @escaping ([Petition]?, (any Error)?) -> Void) {
        let urlString: String
        urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                guard let petitionsList = parse(json: data) else { return }
            }
        }
    }
    
    func parse(json: Data) -> [Petition]? {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            let petitions = jsonPetitions.results
            return petitions
        }
    }
}
