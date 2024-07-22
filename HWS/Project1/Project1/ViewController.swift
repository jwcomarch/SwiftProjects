//
//  ViewController.swift
//  Project1
//
//  Created by Jakub Włodarski on 11/07/2024.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path).sorted()
        
        for i in items {
            if i.hasPrefix("nssl"){
                pictures.append(i)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = pictures[indexPath.row]
        let visitCount = defaults.integer(forKey: name)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = "\(name) Visits: \(visitCount)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.titleBar = "Picture \(indexPath.row + 1) of \(pictures.count)"
            vc.selectedImage = pictures[indexPath.row]
            let name = pictures[indexPath.row]
            var visitCount = defaults.integer(forKey: name)
            visitCount += 1
            defaults.set(visitCount, forKey: name)
            defaults.synchronize()
            tableView.reloadRows(at: [indexPath], with: .none)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

