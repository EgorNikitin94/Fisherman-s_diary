//
//  FolderTableViewController.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 28.01.2021.
//

import UIKit

final class FolderTableViewController: UITableViewController {
    
    //MARK: - Properties
    var folder: Folder?
    
    private var notesActual: [Note] {
        guard let folder = folder else {
            return Storage.notes }
        return folder.notesSorted
    }
    
    private var buyingForm: BuyingForm = BuyingForm()
    
    private var selectedNote: Note?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let folder = folder {
            navigationItem.title = folder.name
        } else {
            navigationItem.title = "All notes".localize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesActual.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteInCell = notesActual[indexPath.row]
        selectedNote = noteInCell
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNote", for: indexPath) as! NoteTableViewCell

        let noteInCell = notesActual[indexPath.row]
        
        cell.configureCellNote(note: noteInCell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.sharedInstance.managedObjectContext.delete(notesActual[indexPath.row])
            CoreDataManager.sharedInstance.saveContext()
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    //MARK: - Actions
    @IBAction private func pushAddAction(_ sender: UIBarButtonItem) {
        
        if buyingForm.isNeedToShow {
            buyingForm.showForm(inController: self)
            return
        }
        selectedNote = Note.newNote(name: "", inFolder: folder)
        selectedNote?.addCurrentLocation()
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNote" {
            (segue.destination as! NoteTableViewController).note = selectedNote
        }
    }

}
