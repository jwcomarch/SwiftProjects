//
//  ViewController.swift
//  MilestoneProject3
//
//  Created by Jakub Włodarski on 22/07/2024.
//

import UIKit

class ViewController: UIViewController {
    var livesLabel: UILabel!
    var wordLabel: UILabel!
    var letterButtons = [UIButton]()
    var correctButtons = [UIButton]()
    var wrongButtons = [UIButton]()
    
    var alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    var wordList = ["EXAMPLE"]
    var wordToGuess = ""
    var wordHidden = ""
    var guessedLetters = ""
    var allHearts = [NSTextAttachment]()
    var livesLost = 0 {
        didSet {
            for index in stride(from: allHearts.count - 1, to: 6 - livesLost, by: -1) {
                allHearts[index] = emptyHeart
            }
            print("Hearts: \(allHearts)")
        }
    }
    
    var filledHeart = NSTextAttachment(image: UIImage(systemName: "heart.fill")!)
    var emptyHeart = NSTextAttachment(image: UIImage(systemName: "heart")!)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        
        livesLabel = UILabel()
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.font = UIFont.systemFont(ofSize: 18)
        livesLabel.textAlignment = .center
        view.addSubview(livesLabel)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.font = UIFont.systemFont(ofSize: 36)
        wordLabel.textAlignment = .center
        view.addSubview(wordLabel)
        
        addLetterButtons(width: 45, height: 45)
        configureUI()
        
        NSLayoutConstraint.activate([
            livesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            livesLabel.heightAnchor.constraint(equalToConstant: 50),
            livesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            livesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),

            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.topAnchor.constraint(equalTo: livesLabel.bottomAnchor, constant: 10),
            wordLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    func addLetterButtons(width: Int, height: Int) {
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        for row in 0..<5 {
            for column in 0..<6 {
                if row == 4 && column > 1 { continue } else {
                    let letterButton = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                    letterButton.setTitle("W", for: .normal)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                    letterButton.layer.borderWidth = 1
                    letterButton.layer.borderColor = UIColor.lightGray.cgColor
                    
                    let frame = CGRect(x: column * width, y: row * height, width: width - 5, height: height - 5)
                    letterButton.frame = frame
                    
                    buttonsView.addSubview(letterButton)
                    letterButtons.append(letterButton)
                }
            }
        }
        NSLayoutConstraint.activate([
            buttonsView.widthAnchor.constraint(equalToConstant: 270),
            buttonsView.heightAnchor.constraint(equalToConstant: 225),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
    }
    
    func configureUI() {
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt"){
            if let word = try? String(contentsOf: wordsURL){
                wordList = word.components(separatedBy: "\n")
                wordList = wordList.map { $0.uppercased() }
            }
        }
        fillHearts()
        updateLives()
        wordToGuess = wordList.randomElement()!
        updateWord()
        
        for index in letterButtons.indices {
            letterButtons[index].setTitle(String(alphabet[index]), for: .normal)
        }
    }
    
    @objc func restartGame() {
        wordToGuess = wordList.randomElement()!
        guessedLetters = ""
        updateWord()
        livesLost = 0
        fillHearts()
        updateLives()
        for index in 0..<26 {
            letterButtons[index].setTitle(String(alphabet[index]), for: .normal)
            letterButtons[index].isUserInteractionEnabled = true
            letterButtons[index].backgroundColor = .systemBackground
        }
    }
    
    func updateWord() {
        var hiddenWord = ""
        for letter in wordToGuess {
            if guessedLetters.contains(letter) {
                hiddenWord += "\(letter) "
            } else {
                hiddenWord += "_ "
            }
        }
        wordHidden = String(hiddenWord.dropLast())
        wordLabel.text = wordHidden
        if (wordHidden.filter { !$0.isWhitespace } == wordToGuess) {
            gameFinished()
        }
    }
    
    func gameFinished() {
        let message: String
        
        if livesLost > 6 {
            message = "You lost! The word was \(wordToGuess)."
        } else {
            message = "You won!"
        }
        
        let ac = UIAlertController(title: "Game Finished!", message: message, preferredStyle: .alert)

        let restartAction = UIAlertAction(title: "Play again", style: .default) {
            [weak self] _ in
            self?.restartGame()
        }
        ac.addAction(restartAction)
        present(ac, animated: true)
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        if !wordToGuess.contains(buttonTitle) {
            sender.backgroundColor = .lightGray
            sender.isUserInteractionEnabled = false
            livesLost += 1
            updateLives()
        } else {
            sender.backgroundColor = .systemGreen
            sender.isUserInteractionEnabled = false
            guessedLetters.append(buttonTitle)
            updateWord()
        }
    }
    
    func fillHearts() {
        allHearts.removeAll()
        for _ in 0 ..< 7 {
            allHearts.append(filledHeart)
        }
    }
    
    func updateLives() {
        let livesLeftText = NSMutableAttributedString(string: "Lives left: ")
        
        for index in 0 ..< 7 {
            livesLeftText.append(NSMutableAttributedString(attachment: allHearts[index]))
            livesLeftText.append(NSAttributedString(string: " "))
        }
        livesLabel.attributedText = livesLeftText
        
        if livesLost == 7 {
            gameFinished()
        }
    }
}
