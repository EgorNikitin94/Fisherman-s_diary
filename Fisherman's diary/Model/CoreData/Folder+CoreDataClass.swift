//
//  Folder+CoreDataClass.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 28.01.2021.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    
    class func newFolder(name: String) -> Folder {
        
        let folder = Folder(context: CoreDataManager.sharedInstance.managedObjectContext)
        
        folder.name = name
        folder.dataUpdate = Date()
        
        return folder
    }
    
    
    var notesSorted: [Note] {
        let sortDescriptor = NSSortDescriptor(key: "dateUpdate", ascending: false)
        return self.notes?.sortedArray(using: [sortDescriptor]) as! [Note]
    }
    
    func addNote() -> Note {
        
        let note = Note(context: CoreDataManager.sharedInstance.managedObjectContext)

        note.folder = self
        note.dateUpdate = Date()
        
        return note
        
    }
    
}
