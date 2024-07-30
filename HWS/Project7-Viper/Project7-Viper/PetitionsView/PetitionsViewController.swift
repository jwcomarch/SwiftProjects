//
//  ViewController.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 29/07/2024.
//

import UIKit

class PetitionsViewController: UITableViewController, PetitionsView {
    private let presenter: PetitionsPresenter
    private var petitions = [Petition]()
    
    init(presenter: PetitionsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad(view: self)
    }

    func show(petitionsList: [Petition]) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
}

