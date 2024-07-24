//
//  ViewController.swift
//  MilestoneProject2
//
//  Created by Jakub Włodarski on 18/07/2024.
//

import UIKit

class ViewController: UITableViewController {
    var itemList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        configureNavButtons()
    }
    
    func configureNavButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add item to list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let input = ac?.textFields?[0].text else { return }
            if !input.isEmpty {
                self?.submit(input)
            }
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func shareList() {
        let list = itemList.joined(separator: "\n")
        if list.isEmpty {
            let ac = UIAlertController(title: "Empty list", message: "Add items to the list before sharing.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        } else {
            let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }
    
    @objc func clearList() {
        if itemList.isEmpty { return }
        let ac = UIAlertController(title: "Warning", message: "This will clear \(itemList.count) elements in the list. Do you want to continue?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.itemList.removeAll()
            self.tableView.reloadData()
        }
        ac.addAction(okAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func submit(_ input: String) {
        itemList.append(input)
        let indexPath = [IndexPath(row: itemList.count - 1, section: 0)]
        tableView.insertRows(at: indexPath, with: .automatic)
        
        return
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row]
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .systemGray
        deleteButton.tag = indexPath.row
        deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        
        cell.contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        return cell
    }
    
    @objc func deleteItem(_ sender: UIButton) {
        itemList.remove(at: sender.tag)
        let indexPath = [IndexPath(row: sender.tag, section: 0)]
        tableView.deleteRows(at: indexPath, with: .automatic)
        tableView.reloadData()
    }
}
