//
//  CardSelectionVC.swift
//  CardWorkout-Programmatic
//
//  Created by Jakub Włodarski on 08/07/2024.
//

import UIKit

class CardSelectionVC: UIViewController {
    
    let cardImageView   = UIImageView()
    let stopButton      = CWButton(backgroundColor: .systemRed, title: "Stop!")
    let restartButton   = CWButton(backgroundColor: .systemGreen, title: "Restart")
    let rulesButton     = CWButton(backgroundColor: .systemBlue, title: "Rules")
    var customBackgroundColor = UIColor.systemBackground
    
    //var customBgColor   = UIColor.systemBackground
    
    let cards: [UIImage] = Deck.allValues
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customBackgroundColor
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer.invalidate()
    }
    
    @objc func presentColorVC(){
        self.navigationController?.pushViewController(ColorsVC(), animated: true)
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector( showRandomImage), userInfo: nil, repeats: true)
    }
    
    @objc func stopTimer(){
        timer.invalidate()
    }
    
    @objc func restartTimer(){
        timer.invalidate()
        startTimer()
    }
    
    @objc func showRandomImage(){
        cardImageView.image = cards.randomElement() ?? UIImage(named: "AC")
    }
    
    func configureUI(){
        configureNavigationBar()
        configureCardImageView()
        configureStopButton()
        configureRestartButton()
        configureRulesButton()
    }
    
    func configureNavigationBar(){
        self.navigationItem.title = "Cards App"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change color", style: .plain, target: self, action: #selector(presentColorVC))
    }
    
    func configureCardImageView(){
        view.addSubview(cardImageView)
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.image = UIImage(named: "AS")
        
        NSLayoutConstraint.activate([
            cardImageView.widthAnchor.constraint(equalToConstant: 260),
            cardImageView.heightAnchor.constraint(equalToConstant: 350),
            cardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75)
        ])
    }
    
    func configureStopButton(){
        view.addSubview(stopButton)
        stopButton.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stopButton.widthAnchor.constraint(equalToConstant: 250),
            stopButton.heightAnchor.constraint(equalToConstant: 50),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 30)
        ])
    }
    
    func configureRestartButton(){
        view.addSubview(restartButton)
        restartButton.addTarget(self, action: #selector(restartTimer), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            restartButton.widthAnchor.constraint(equalToConstant: 115),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            restartButton.leadingAnchor.constraint(equalTo: stopButton.leadingAnchor),
            restartButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 15)
        ])
    }
    
    func configureRulesButton(){
        view.addSubview(rulesButton)
        rulesButton.addTarget(self, action: #selector(presentRulesVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            rulesButton.widthAnchor.constraint(equalToConstant: 115),
            rulesButton.heightAnchor.constraint(equalToConstant: 50),
            rulesButton.trailingAnchor.constraint(equalTo: stopButton.trailingAnchor),
            rulesButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 15)
        ])
    }
    
    @objc func presentRulesVC(){
        let rulesVCInstance = RulesVC()
        present(rulesVCInstance, animated: true)
        rulesVCInstance.view.backgroundColor = self.view.backgroundColor
    }

}
