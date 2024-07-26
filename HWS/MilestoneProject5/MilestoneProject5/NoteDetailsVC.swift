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
    var noteTitleString: String!
    var noteContentString: String!
    @IBOutlet var noteContent: UITextView!
    @IBOutlet var noteTitle: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTitle.text = noteTitleString
        noteContent.text = noteContentString
        addNotificationObservers()
        noteContent.becomeFirstResponder()
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "doc"), style: .plain, target: self, action: #selector(saveNote))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareNote))
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteNote))
        
        navigationItem.rightBarButtonItems = [saveButton, shareButton, deleteButton]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if indexInArray >= 0 {
            saveNote()
        }
    }
    
    @objc func saveNote() {
        if let rootVC = navigationController?.viewControllers.first as? ViewController {
            rootVC.notes[indexInArray] = Note(title: noteTitle.text, content: noteContent.text, editDate: rootVC.getCurrentDate())
            rootVC.tableView.reloadData()
            rootVC.saveNotes()
        }
    }
    
    @objc func shareNote() {
        if noteContent.text.isEmpty {
            let ac = UIAlertController(title: "Can't share empty note!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        let vc = UIActivityViewController(activityItems: [noteContent.text!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func deleteNote() {
        let ac = UIAlertController(title: "This will delete \(noteTitle.text ?? "this note").", message: "Do you want to continue?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            if let rootVC = self?.navigationController?.viewControllers.first as? ViewController {
                rootVC.notes.remove(at: self!.indexInArray)
                self?.indexInArray = -1
                rootVC.tableView.reloadData()
                rootVC.saveNotes()
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        ac.addAction(deleteAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func addNotificationObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteContent.contentInset = .zero
        } else {
            noteContent.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        noteContent.scrollIndicatorInsets = noteContent.contentInset
        
        let selectedRange = noteContent.selectedRange
        noteContent.scrollRangeToVisible(selectedRange)
    }
}
