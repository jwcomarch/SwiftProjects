//
//  ViewController.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 29/07/2024.
//

import UIKit

//View
protocol PetitionsView: AnyObject {
    func setPetitions(petitionsList: [Petition])
}

class PetitionsViewController: UITableViewController, PetitionsView {
    
    var presenter: PetitionsPresenter?
    var petitions = [Petition]()

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
        let ac = UIAlertController(title: "Filter results", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            guard let userInput = ac?.textFields?[0].text else { return }
            self?.presenter?.setPetitions(with: userInput)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in

            self?.presenter?.setPetitions(with: "")
        }
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
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
        presenter?.showDetails(petition: petitions[indexPath.row])
    }
}

