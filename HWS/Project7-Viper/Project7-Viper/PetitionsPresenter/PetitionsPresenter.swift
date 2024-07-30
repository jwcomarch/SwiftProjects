//
//  PetitionsPresenter.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation

final class PetitionsPresenterImplementation: PetitionsPresenter {
    private weak var view: PetitionsView?
    private let router: PetitionsRouter
    private let interactor: PetitionsInteractorInput
    
    init(router: PetitionsRouter, interactor: PetitionsInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad(view: PetitionsView) {
        self.view = view
    }
}

extension PetitionsPresenterImplementation: PetitionsInteractorOutput {
    func fetchPetitionsListSuccess(petitionsList: [Petition]) {
        <#code#>
    }
    
    func fetchPetitionsListFailure(error: (any Error)?) {
        <#code#>
    }
    
    
}
