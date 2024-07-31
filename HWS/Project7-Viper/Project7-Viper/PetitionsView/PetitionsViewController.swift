//
//  ViewController.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 29/07/2024.
//

import UIKit

//View
protocol PetitionsView: AnyObject {
    func setPetitions(petitionsList: [Petition]) //set 'petitions' array + tableView.reloadData()
    //func getPetitions()
    
    //filter feature:
    //VIEW passes string to presenter ->
    //PRESENTER passes it to Interactor and modifies presenter's 'petitions' array ->
    
}

class PetitionsViewController: UITableViewController, PetitionsView {
    
    //var presenter: PetitionsViewPresenter?
    var presenter: PetitionsPresenter?
    var petitions = [Petition]()
    
//    init(presenter: PetitionsPresenter) {
//        self.presenter = presenter
//        super.init(nibName: nil, bundle: nil)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        //fatalError("init(coder:) has not been implemented")
//        self.presenter = PetitionsPresenterImplementation(view: self)
//        super.init(coder: aDecoder)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = PetitionsPresenterImplementation(view: self)
        //show(petitionsList: petitions)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "doc.text.magnifyingglass"), style: .plain, target: self, action: #selector(filterResults))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
    }

    func setPetitions(petitionsList: [Petition]) {
        petitions = petitionsList
        tableView.reloadData()
    }
    
    @objc func filterResults() {
        
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data used in the app comes from We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Petition", for: indexPath)
        
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetailVC()
//        vc.detailItem = petitions[indexPath.row]
//        navigationController?.pushViewController(vc, animated: true)
    }
}

