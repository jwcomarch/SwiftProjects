//
//  ScriptsVC.swift
//  Extension
//
//  Created by Jakub Włodarski on 24/07/2024.
//

import UIKit

class ScriptsVC: UITableViewController {
    var userScripts = [Script]()
    let defaults = UserDefaults.standard
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        print("User script title: \(userScripts[0].title)")
        tableView.reloadData()
    }
    
    func load() {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let savedData = defaults.object(forKey: pageURL) as? Data {
            do {
                userScripts = try jsonDecoder.decode([Script].self, from: savedData)
            } catch {
                print("Failed to load user scripts.")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScripts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for: indexPath)
        cell.textLabel?.text = userScripts[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let rootVC = navigationController?.viewControllers.first as? ActionViewController {
            rootVC.script.text = userScripts[indexPath.row].js
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
