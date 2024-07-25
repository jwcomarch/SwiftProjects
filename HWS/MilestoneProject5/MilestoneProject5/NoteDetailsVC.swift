//
//  NoteDetailsVC.swift
//  MilestoneProject5
//
//  Created by Jakub Włodarski on 25/07/2024.
//

import UIKit

class NoteDetailsVC: UIViewController {
    let defaults = UserDefaults.standard
    var indexInArray: Int!
    var noteTitle: String!
    var noteContentString: String!
    @IBOutlet var noteContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = noteTitle
        noteContent.text = noteContentString
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote))
    }
    
    @objc func saveNote() {
        if let rootVC = navigationController?.viewControllers.first as? ViewController {
            rootVC.notes[indexInArray] = Note(title: noteTitle, content: noteContent.text)
            rootVC.tableView.reloadData()
            rootVC.save()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let rootVC = navigationController?.viewControllers.first as? ViewController {
            rootVC.notes[indexInArray] = Note(title: noteTitle, content: noteContent.text)
            rootVC.tableView.reloadData()
            rootVC.save()
        }
    }
}
