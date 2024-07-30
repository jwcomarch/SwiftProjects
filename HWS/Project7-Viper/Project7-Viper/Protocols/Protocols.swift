//
//  Protocols.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation

protocol PetitionsView: AnyObject {
    func show(petitionsList: [Petition])
}

protocol PetitionsPresenter: AnyObject {
    func viewDidLoad(view: PetitionsView)
}

protocol PetitionsInteractorInput: AnyObject {
    func fetchPetitionsList()
}

protocol PetitionsInteractorOutput: AnyObject {
    func fetchPetitionsListSuccess(petitionsList: [Petition])
    func fetchPetitionsListFailure(error: Error?)
}

protocol PetitionsRepo: AnyObject {
    func fetchPetitions(completion: @escaping ([Petition]?, Error?) -> Void)
}

protocol PetitionsRouter: AnyObject {
    
}
