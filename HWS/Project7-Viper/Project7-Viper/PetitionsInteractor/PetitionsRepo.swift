//
//  PetitionsRepo.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation
import UIKit

protocol PetitionsRepo: AnyObject {
    func fetchPetitions(from barTag: Int, completion: @escaping ([Petition]?) -> Void)
}

class PetitionsRepoImplementation: PetitionsRepo {
    
    private let urlString: [String] = [
        "https://www.hackingwithswift.com/samples/petitions-1.json",
        "https://www.hackingwithswift.com/samples/petitions-2.json"
    ]
    
    func fetchPetitions(from barTag: Int, completion: @escaping ([Petition]?) -> Void) {
        let urlString = urlString[barTag]
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    if let petitions = self.parse(json: data) {
                        completion(petitions)
                        return
                    }
                }
            }
            completion(nil)
        }
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
