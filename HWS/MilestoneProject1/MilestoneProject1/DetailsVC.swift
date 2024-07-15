//
//  DetailsVC.swift
//  MilestoneProject1
//
//  Created by Jakub Włodarski on 15/07/2024.
//

import UIKit

class DetailsVC: UIViewController {
    @IBOutlet var flagImage: UIImageView!
    var selectedFlag: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        if let flagToLoad = selectedFlag{
            flagImage.image = UIImage(named: flagToLoad)
        }
    }
    
    @objc func shareTapped(){
        let message = "This is \(selectedFlag!.dropLast(3))'s flag."
        guard let image = flagImage.image?.pngData() else {
            print("No image found.")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, message], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
}
