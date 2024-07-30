//
//  PetitionsInteractor.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation

final class PetitionsInteractor: PetitionsInteractorInput {
    weak var output: PetitionsInteractorOutput?
    
    private let repo: PetitionsRepo
    
    init(repo: PetitionsRepo) {
        self.repo = repo
    }
    
    func fetchPetitionsList() {
        <#code#>
    }
}
