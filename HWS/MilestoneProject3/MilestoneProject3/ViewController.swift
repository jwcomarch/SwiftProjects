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
    var livesLeftText = NSMutableAttributedString()
    var livesLost = 0
    
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
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let width = 45
        let height = 45
        
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
        
        configureUI()
        
        NSLayoutConstraint.activate([
            buttonsView.widthAnchor.constraint(equalToConstant: 270),
            buttonsView.heightAnchor.constraint(equalToConstant: 225),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            
            livesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            livesLabel.heightAnchor.constraint(equalToConstant: 50),
            livesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            livesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),

            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.topAnchor.constraint(equalTo: livesLabel.bottomAnchor, constant: 10),
            wordLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        
    }
    
    func configureUI() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWord = try? String(contentsOf: startWordsURL){
                wordList = startWord.components(separatedBy: "\n")
                wordList = wordList.map { $0.uppercased() }
            }
        }
        updateLives()
        
        wordToGuess = wordList.randomElement()!
        print("Word: \(wordToGuess)")
        updateWord()
        
        for index in 0..<26 {
            letterButtons[index].setTitle(String(alphabet[index]), for: .normal)
        }
    }
    
    @objc func restartGame() {
        wordToGuess = wordList.randomElement()!
        print("New word: \(wordToGuess)")
        guessedLetters = ""
        updateWord()
        livesLost = 0
        updateLives()
        for index in 0..<26 {
            letterButtons[index].setTitle(String(alphabet[index]), for: .normal)
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
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        let letterPositions = wordToGuess.enumerated().compactMap { $1 == Character(buttonTitle) ? $0 : nil }
        
        if letterPositions.isEmpty {
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
    
    func updateLives() {
        livesLeftText = NSMutableAttributedString(string: "Lives left: ")
        for _ in 0 ..< 7 - livesLost {
            livesLeftText.append(NSAttributedString(attachment: filledHeart))
            livesLeftText.append(NSAttributedString(string: " "))
        }
        
        for _ in 0 ..< livesLost {
            livesLeftText.append(NSAttributedString(attachment: emptyHeart))
            livesLeftText.append(NSAttributedString(string: " "))
        }
        
        livesLabel.attributedText = livesLeftText
    }
}
