//
//  FoldersTableViewController.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 28.01.2021.
//

import UIKit

final class FoldersTableViewController: UITableViewController {
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.sharedInstance.requestAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Actions
    @IBAction private func pushAddAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create new folder".localize(), message: nil, preferredStyle: .alert)
        alertController.addTextField { (text) in
            text.placeholder = "Place name".localize()
        }
        let alertActionAdd = UIAlertAction(title: "Create".localize(), style: .default) { (alert) in
            let folderName = alertController.textFields?[0].text
            if folderName != "" {
                _ = Folder.newFolder(name: folderName!.uppercased())
                CoreDataManager.sharedInstance.saveContext()
                self.tableView.reloadData()
            }
        }
        let alertActionCancel = UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil)
        alertController.addAction(alertActionAdd)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
    }
        
    // MARK: - Table view data source and delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Storage.folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFolder", for: indexPath)
        
        let folderInCell = Storage.folders[indexPath.row]
        cell.textLabel?.text = folderInCell.name
        cell.detailTextLabel?.text = "\(folderInCell.notes!.count) item(-s)"
        cell.imageView?.image = UIImage(systemName: "folder.fill")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let folderInCell = Storage.folders[indexPath.row]
            CoreDataManager.sharedInstance.managedObjectContext.delete(folderInCell)
            CoreDataManager.sharedInstance.saveContext()
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToFolder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFolder" {
            let selectedFolder = Storage.folders[tableView.indexPathForSelectedRow!.row]
            (segue.destination as! FolderTableViewController).folder = selectedFolder
        }
    }
}
