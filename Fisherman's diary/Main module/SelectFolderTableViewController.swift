//
//  SelectFolderTableViewController.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 03.02.2021.
//

import UIKit

final class SelectFolderTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var note: Note?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Storage.folders.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)

        if indexPath.row == 0 {
            cell.textLabel?.text = "-"
            if note?.folder == nil {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            let folder = Storage.folders[indexPath.row - 1]
            cell.textLabel?.text = folder.name
            if folder == note?.folder {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            note?.folder = nil
        } else {
            let folder = Storage.folders[indexPath.row - 1]
            note?.folder = folder
        }
        tableView.reloadData()
    }
}
