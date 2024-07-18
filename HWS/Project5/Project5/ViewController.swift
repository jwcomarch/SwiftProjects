//
//  ViewController.swift
//  Project5
//
//  Created by Jakub Włodarski on 16/07/2024.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = ["silkworm"]
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWord = try? String(contentsOf: startWordsURL){
                allWords = startWord.components(separatedBy: "\n")
            }
        }
        
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func restartGame() {
        startGame()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let wordCheck = isWordAcceptable(word: lowerAnswer)
        if wordCheck {
            usedWords.insert(answer, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            return
        }
    }
    
    func isWordAcceptable(word: String) -> Bool{
        var errorTitle = "Error"
        var errorMsg = "Unexpected error occurred. Please contact app developer."
        guard let title = title else { return false }
        
        let wordChecks: [Bool] = [
            isLongEnough(word: word),
            isPossible(word: word),
            isOriginal(word: word),
            isNotTitle(word: word),
            isReal(word: word),]
        
        for (index, wordCheck) in wordChecks.enumerated() {
            if !wordCheck {
                switch(index){
                case 0:
                    errorTitle = "Word too short"
                    errorMsg = "Word must be at least 3 letters long."
                case 1:
                    errorTitle = "Word not possible"
                    errorMsg = "You can't spell that word from \(title.lowercased())!"
                case 2:
                    errorTitle = "Word already used"
                    errorMsg = "Be more original!"
                case 3:
                    errorTitle = "Word not allowed"
                    errorMsg = "Word inputted must not be the same as the title."
                default:
                    errorTitle = "Word not recognized"
                    errorMsg = "You can't input made up words!"
                }
                
                let ac = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                
                return false
            }
        }
        
        return true
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.utf16.count > 2
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let wordLength = word.utf16.count
        let range = NSRange(location: 0, length: wordLength)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return (misspelledRange.location == NSNotFound
                && wordLength > 2
                && word != title?.lowercased())
    }
    
    func isNotTitle(word: String) -> Bool {
        return word != title!.lowercased()
    }
}
