//
//  PetitionsRouter.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 30/07/2024.
//

import Foundation
import UIKit

protocol PetitionsRouter: AnyObject {
    func present(parentViewController: UIViewController, params: Petition)
    //func createWindow(windowScene: UIWindowScene) -> UIWindow
}

class PetitionsRouterImplementation: PetitionsRouter {    
    
    weak var viewController: UIViewController?
    
    func present(parentViewController: UIViewController, params: Petition) {
        let newViewController = UIViewController()
        parentViewController.present(newViewController, animated: true)
    }
    
//    func createWindow(windowScene: UIWindowScene) -> UIWindow {
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = UINavigationController(rootViewController: viewController!)
//        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window.windowScene = windowScene
//        window.rootViewController = vc
//        window.makeKeyAndVisible()
//        return window
//    }
}
