//
//  ViewController.swift
//  MilestoneProject5
//
//  Created by Jakub Włodarski on 25/07/2024.
//

import UIKit

class ViewController: UITableViewController {
    let defaults = UserDefaults.standard
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        tableView.reloadData()
        
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        let clearNotesButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotes))
        toolbarItems = [clearNotesButton, addNoteButton]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func addNote() {
        let ac = UIAlertController(title: "Add note title", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            self?.notes.append(Note(title: ac?.textFields?.first?.text ?? "New note"))
            self?.tableView.reloadData()
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func clearNotes() {
        notes.removeAll()
        tableView.reloadData()
        save()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "UserNotes")
        } else {
            print("Failed to save notes.")
        }
    }
    
    func load() {
        if let savedData = defaults.object(forKey: "UserNotes") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedData)
            } catch {
                print("Failed to load notes.")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoteDetails") as! NoteDetailsVC
        vc.indexInArray = indexPath.row
        vc.noteTitle = notes[indexPath.row].title
        vc.noteContentString = notes[indexPath.row].content
        navigationController?.pushViewController(vc, animated: true)
    }
}

