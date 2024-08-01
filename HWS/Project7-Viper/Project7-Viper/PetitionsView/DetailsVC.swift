//
//  DetailsVC.swift
//  Project7-Viper
//
//  Created by Jakub Włodarski on 01/08/2024.
//

import UIKit
import WebKit

protocol DetailsView {
    func setPetition(to petition: Petition)
}

class DetailsVC: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        title = detailItem.title
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func setPetition(to petition: Petition) {
        detailItem = petition
    }
}
