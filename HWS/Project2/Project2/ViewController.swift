//
//  ViewController.swift
//  Project2
//
//  Created by Jakub Włodarski on 11/07/2024.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var answerCount = 0
    
    let defaults = UserDefaults.standard
    private let topScoreKey = "TopScore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showPoints))
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        registerLocal()
        scheduleLocal()
    }
    
    @objc func showPoints(){
        let title = "Your current score is \(score)."
        let message = "There is \(10 - answerCount) questions left."
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
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
            let topScoreMsg: String
            if score > defaults.integer(forKey: topScoreKey) {
                topScoreMsg = ". This is the new high score!"
                defaults.set(score, forKey: topScoreKey)
            } else {
                topScoreMsg = ""
            }
            alertMessage.0 = "Game finished! \n Your final score is \(score)" + topScoreMsg
            alertMessage.1 = "Play again"
            score = 0
            answerCount = 0
        }
        
        let ac = UIAlertController(title: title, message: alertMessage.0, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: alertMessage.1, style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Flag App"
        content.body = "Play at least 1 game a day to increase your flag recognition skill!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 24
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Open App", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

