//
//  ColorsDetailViewController.swift
//  RandomColors
//
//  Created by Jakub Włodarski on 05/07/2024.
//

import UIKit

class ColorsDetailViewController: UIViewController {
    var color: UIColor?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color ?? .systemBackground
        configureAlertController()
    }
    
    func configureAlertController(){
        
    }
    
    @IBAction func alertButtonTapped(_ sender: UIButton) {
        let alertMessage = hexStringFromColor(color: color ?? UIColor.white)
        let alert = UIAlertController(title: "Color", message: alertMessage, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        let backAction = UIAlertAction.init(title: "Back to Table", style: .default){_ in
    self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(closeAction)
        alert.addAction(backAction)
        
        present(alert, animated: true)
    }
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    
}
