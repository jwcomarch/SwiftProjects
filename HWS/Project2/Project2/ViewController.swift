//
//  ViewController.swift
//  Project2
//
//  Created by Jakub Włodarski on 11/07/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var answerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        let answer = countries[correctAnswer]
        let capitalizedCountry = answer.count < 3 ? answer.uppercased() : answer.capitalized
        
        title = "Score: \(score) | Which flag is \(capitalizedCountry)? | \(answerCount + 1)/10"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var alertMessage: (String, String)
        answerCount += 1
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        } else {
            let answer = countries[sender.tag]
            let capitalizedCountry = answer.count < 3 ? answer.uppercased() : answer.capitalized
            title = "Wrong! That's the flag of \(capitalizedCountry)"
            score -= 1
        }
        
        if answerCount < 10 {
            alertMessage.0 = "Your score is \(score)"
            alertMessage.1 = "Continue"
        } else {
            alertMessage.0 = "Game finished! \n Your final score is \(score)"
            alertMessage.1 = "Play again"
            score = 0
            answerCount = 0
        }
        
        let ac = UIAlertController(title: title, message: alertMessage.0, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: alertMessage.1, style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
}

