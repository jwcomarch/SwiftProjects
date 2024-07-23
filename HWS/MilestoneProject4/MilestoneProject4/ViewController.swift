//
//  ViewController.swift
//  MilestoneProject4
//
//  Created by Jakub Włodarski on 23/07/2024.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTable))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
             let jsonDecoder = JSONDecoder()
             do {
                 pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
                 print(pictures)
             } catch {
                 print("Failed to load pictures")
             }
         }
    }
    
    @objc func addPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func clearTable() {
        let ac = UIAlertController(title: "Warning", message: "This delete all saved images. Do you want to continue?", preferredStyle: .alert)
        
        let clearAction = UIAlertAction(title: "OK", style: .default) { [self] _ in
            self.pictures.removeAll()
            self.tableView.reloadData()
            self.save()
        }
        ac.addAction(clearAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Caption", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? PictureDetailsVC {
            vc.titleBar = pictures[indexPath.row].caption
            vc.selectedPicture = pictures[indexPath.row].image
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Add caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let caption = ac?.textFields?.first?.text != "" ? ac?.textFields?.first?.text : "Unknown" else { return }
            let newPicture = Picture(image: imageName, caption: caption)
            self?.pictures.append(newPicture)
            self?.tableView.reloadData()
            self?.save()
        }
        ac.addAction(submitAction)
        present(ac, animated: false)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
            print("Saved")
        } else {
            print("Failed to save pictures.")
        }
    }
    
    func getDocumentsDirectory() -> URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
}

