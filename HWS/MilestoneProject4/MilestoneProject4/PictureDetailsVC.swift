//
//  PictureDetailsVC.swift
//  MilestoneProject4
//
//  Created by Jakub Włodarski on 23/07/2024.
//

import UIKit

class PictureDetailsVC: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedPicture: String?
    var titleBar: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleBar ?? selectedPicture        
        if let imageToLoad = selectedPicture {
            let path = getDocumentsDirectory().appendingPathComponent(imageToLoad)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
