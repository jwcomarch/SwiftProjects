//
//  ColorsVC.swift
//  CardWorkout-Programmatic
//
//  Created by Jakub Włodarski on 09/07/2024.
//

import UIKit

class ColorsVC: UIViewController {
    
    var colors: [UIColor] = [UIColor.random(), UIColor.random(), UIColor.random(),]
    let buttons = [CWButton(), CWButton(), CWButton()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureButtons()
    }
    
    func configureButtons(){
        for i in buttons.indices{
            buttons[i].backgroundColor = colors[i]
            buttons[i].setTitle("Color \(i)", for: .normal)
            
            view.addSubview(buttons[i])
            buttons[i].addTarget(self, action: #selector(setColor(sender:)), for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                buttons[i].widthAnchor.constraint(equalToConstant: 100),
                buttons[i].heightAnchor.constraint(equalToConstant: 50),
                buttons[i].centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttons[i].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(-100 + (i * 100)))
            ])
        }
    }
    
    @objc func setColor(sender : UIButton){
        navigationController?.viewControllers.first?.view.backgroundColor = sender.backgroundColor ?? .systemRed
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

