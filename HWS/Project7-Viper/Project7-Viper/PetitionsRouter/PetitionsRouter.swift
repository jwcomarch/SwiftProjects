//
//  PetitionsRouter.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation
import UIKit

protocol PetitionsRouter: AnyObject {
    func presentDetails(parentViewController: UIViewController, petition: Petition)
}

class PetitionsRouterImplementation: PetitionsRouter {
    
    func presentDetails(parentViewController: UIViewController, petition: Petition) {
        let vc = DetailsVC()
        vc.setPetition(to: petition)
        parentViewController.navigationController?.pushViewController(vc, animated: true)
    }
}
