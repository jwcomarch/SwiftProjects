//
//  ColorsDetailViewController.swift
//  RandomColors
//
//  Created by Jakub Włodarski on 05/07/2024.
//

import UIKit

class ColorsDetailViewController: UIViewController {
    
    var color: UIColor?
    var alertMessage: String = ""
    var alert = UIAlertController(title: "Color", message: "An error occurred.", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color ?? .systemBackground
        alertMessage = hexStringFromColor(color: color ?? UIColor.white)
        alert = UIAlertController(title: "Color", message: self.alertMessage, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        let backAction = UIAlertAction.init(title: "Back to Table", style: .default){_ in
            self.navigationController?.popViewController(animated: true)            
        }
        alert.addAction(closeAction)
        alert.addAction(backAction)
    }
    
    @IBAction func alertButtonTapped(_ sender: UIButton) {
        present(alert, animated: true)
    }
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
    }
    
}
