//
//  ActionViewController.swift
//  Extension
//
//  Created by Jakub Włodarski on 23/07/2024.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    var savedScripts = [String: String]()
    var userScripts = [Script]()
    
    let defaults = UserDefaults.standard
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chooseScript = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showScripts))
        let addScript = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCustomScript))
        let showUserScripts = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showUserScriptsTable))
        navigationItem.leftBarButtonItems = [chooseScript, showUserScripts, addScript]
        
        let clearTextView = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTextView))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(done))
        navigationItem.rightBarButtonItems = [doneButton, clearTextView]
        
        addPredefinedScripts()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
                load()
            }
        }
    }
    
    func addPredefinedScripts() {
        savedScripts["Title Alert"] = "alert(document.title);"
    }
    
    @objc func clearTextView() {
        script.text = ""
    }
    
    @objc func showUserScriptsTable() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserScripts") as! ScriptsVC
        vc.title = "User scripts for \(pageTitle):"
        vc.pageURL = self.pageURL
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addCustomScript() {
        var ac = UIAlertController()
        if !script.text.isEmpty {
            ac = UIAlertController(title: "Add a title to the following script:", message: script.text, preferredStyle: .alert)
            ac.addTextField()
            let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                self?.userScripts.append(Script(title: ac?.textFields?.first?.text ?? "Custom Script", js: self!.script.text))
                self?.save()
            }
            ac.addAction(submitAction)
        } else {
            ac = UIAlertController(title: "Empty script", message: "Can't add empty script!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        }
        present(ac, animated: true)
    }
    
    @objc func showScripts() {
        let ac = UIAlertController(title: "Select script", message: nil, preferredStyle: .actionSheet)
        var scriptsToShow = [UIAlertAction]()
        for script in savedScripts {
            scriptsToShow.append(UIAlertAction(title: script.key, style: .default) { [weak self] _ in
                self?.script.text = script.value
            })
            ac.addAction(scriptsToShow.last!)
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func load() {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let savedData = defaults.object(forKey: pageURL) as? Data {
            do {
                userScripts = try jsonDecoder.decode([Script].self, from: savedData)
            } catch {
                print("Failed to load user scripts.")
            }
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(userScripts) {
            defaults.setValue(savedData, forKey: pageURL)
        } else {
            print("Failed to save user scripts.")
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
}
