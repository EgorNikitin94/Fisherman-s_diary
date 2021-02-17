//
//  NoteTableTableViewController.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 02.02.2021.
//

import UIKit

final class NoteTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var note: Note?
    
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    
    @IBOutlet private var emptyImageView: UIImageView!
    
    @IBOutlet private var photoImageView: UIImageView! {
        didSet {
            photoImageView.image = note?.imageActual
        }
    }
    
    @IBOutlet private var nameTextField: UITextField! {
        didSet {
            nameTextField.text = note?.name
        }
    }
    
    @IBOutlet private var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.text = note?.discription
        }
    }
    
    @IBOutlet private var folderLabel: UILabel!
    
    @IBOutlet private var folderNameLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if let folder = note?.folder {
            folderNameLabel.text = folder.name
        } else {
            folderNameLabel.text = "-"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        photoImageView.layer.masksToBounds = true
        navigationItem.title = note?.name
        imagePicker.delegate = self
    }
    
    //MARK: - Actions
    
    @IBAction private func pushShareAction(_ sender: UIBarButtonItem) {
        
        var activities: [Any] = []
        if let image = note?.imageActual {
            activities.append(image)
        }
        
        activities.append(note?.name ?? "")
        activities.append(note?.description ?? "")
        
        let activityVC = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction private func pushDoneAction(_ sender: UIBarButtonItem) {
        saveNote()
        navigationController?.popViewController(animated: true)
    }
    
    private func saveNote() {
        if nameTextField.text == "" && descriptionTextView.text == "" && photoImageView.image == nil {
            CoreDataManager.sharedInstance.managedObjectContext.delete(note!)
            CoreDataManager.sharedInstance.saveContext()
            return
        }
        
        if note?.name != nameTextField.text || note?.discription != descriptionTextView.text {
            note?.dateUpdate = Date()
        }
        note?.name = nameTextField.text
        note?.discription = descriptionTextView.text
        note?.imageActual = photoImageView.image
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row == 0 && indexPath.section == 0 else {return}
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionOneCamera = UIAlertAction(title: "Make a photo".localize(), style: .default, handler: { (alert) in
            // Make photo
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        actionController.addAction(actionOneCamera)
        
        let actionTwoPhotos = UIAlertAction(title: "Select from library".localize(), style: .default, handler: {(alert) in
            // Go to the photos library
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        actionController.addAction(actionTwoPhotos)
        
        if photoImageView.image != nil {
            let actionThreeDelete = UIAlertAction(title: "Delete".localize(), style: .destructive) { (alert) in
                self.photoImageView.image = nil
            }
            actionController.addAction(actionThreeDelete)
        }
        let actionFourCancel = UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil)
        actionController.addAction(actionFourCancel)
        
        present(actionController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectFolder" {
            _ = (segue.destination as! SelectFolderTableViewController).note = note
        }
        
        if segue.identifier == "goToMap" {
            _ = (segue.destination as! NoteMapViewController).note = note
        }
    }
    
}

//MARK: - Extensions

extension NoteTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
