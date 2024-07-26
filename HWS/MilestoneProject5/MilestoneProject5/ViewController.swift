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
    let notesCount = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        loadNotes()
        tableView.reloadData()
        
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        let clearNotesButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotes))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [clearNotesButton, spacer, notesCount, spacer, addNoteButton]
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNoteCount()
    }
    
    func updateNoteCount() {
        notesCount.title = "\(notes.count) Notes"
    }
    
    @objc func addNote() {
        let ac = UIAlertController(title: "Add note title", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            let input = ac?.textFields?.first?.text
            self?.notes.append(Note(title: (input != "" ? input : "New note")!, editDate: (self?.getCurrentDate())!))
            self?.tableView.reloadData()
            self?.saveNotes()
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func clearNotes() {
        let ac = UIAlertController(title: "This will clear all notes.", message: "Do you want to continue?", preferredStyle: .alert)
        let continueAction = (UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.notes.removeAll()
            self?.tableView.reloadData()
            self?.saveNotes()
        })
        ac.addAction(continueAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func saveNotes() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "UserNotes")
        } else {
            print("Failed to save notes.")
        }
        updateNoteCount()
    }
    
    func loadNotes() {
        if let savedData = defaults.object(forKey: "UserNotes") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedData)
            } catch {
                print("Failed to load notes.")
            }
        }
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "d MMM yyyy"
        let day = formatter.string(from: date)
        formatter.dateFormat = "HH:mm"
        let hour = formatter.string(from: date)
        return "\(day)\n\(hour)"
    }
    
    func formatDateForCell(date: String) -> NSMutableAttributedString {
        let time = date.components(separatedBy: "\n")
        let attributedDay = NSMutableAttributedString(string: "\(time[0])\n", attributes: [.font: UIFont.systemFont(ofSize: 11)])
        let attributedHour = NSMutableAttributedString(string: time[1], attributes: [.font: UIFont.systemFont(ofSize: 17)])
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(attributedDay)
        attributedString.append(attributedHour)
        
        return attributedString
    }
    
    func configureEditDateLabel(inCell index: Int) -> UILabel {
        let editDate = UILabel()
        editDate.attributedText = formatDateForCell(date: notes[index].editDate)
        editDate.textAlignment = .center
        editDate.numberOfLines = 2
        editDate.textColor = .lightGray
        editDate.translatesAutoresizingMaskIntoConstraints = false
        
        return editDate
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].content == "" ? "(Note is empty)" : notes[indexPath.row].content
        
        let editDate = configureEditDateLabel(inCell: indexPath.row)
        for label in cell.contentView.subviews {
            label.removeFromSuperview()
        }
        cell.contentView.addSubview(editDate)
        
        NSLayoutConstraint.activate([
            editDate.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            editDate.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            editDate.widthAnchor.constraint(equalToConstant: 80),
            editDate.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoteDetails") as! NoteDetailsVC
        vc.indexInArray = indexPath.row
        vc.noteTitleString = notes[indexPath.row].title
        vc.noteContentString = notes[indexPath.row].content
        navigationController?.pushViewController(vc, animated: true)
    }
}

