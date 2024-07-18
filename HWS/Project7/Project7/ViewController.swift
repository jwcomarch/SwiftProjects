//
//  ViewController.swift
//  Project7
//
//  Created by Jakub Włodarski on 17/07/2024.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var allPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Whitehouse Petitions"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "doc.text.magnifyingglass"), style: .plain, target: self, action: #selector(filterResults))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    @objc func filterResults() {
        let ac = UIAlertController(title: "Filter results", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) {
            [self, weak ac] _ in
            guard let userInput = ac?.textFields?[0].text else { return }
            performSelector(inBackground: #selector(submit), with: userInput)
            //self?.submit(userInput)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            self.undoFilter()
        }
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    @objc func submit(_ input: String) {
        if input.isEmpty {
            undoFilter()
            return
        }
        var tempArr = [Petition]()
        for p in petitions {
            if p.title.contains(input) || p.body.contains(input){
                tempArr.append(p)
            }
        }
        petitions = tempArr
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func undoFilter(){
        petitions = allPetitions
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data used in the app comes from We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            allPetitions = petitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVC()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

