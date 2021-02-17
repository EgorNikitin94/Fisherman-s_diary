//
//  Note+CoreDataClass.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 28.01.2021.
//
//

import Foundation
import CoreData
import UIKit

@objc(Note)
public class Note: NSManagedObject {
    
    class func newNote(name: String, inFolder: Folder?) -> Note {
        let note = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        
        note.name = name
        note.dateUpdate = Date()
        
        if let inFolder = inFolder {
            note.folder = inFolder
        }
        CoreDataManager.sharedInstance.saveContext()
        print("Создана новая заметка \(String(describing: note.name))")
        return note
    }
    
    var dateUpdateString: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: self.dateUpdate!)
    }
    
    var imageActual: UIImage? {
        set {
            if newValue == nil {
                if self.image != nil {
                    CoreDataManager.sharedInstance.managedObjectContext.delete(self.image!)
                }
                self.imageSmall = nil
            } else {
                if self.image == nil {
                    self.image = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
                }
                self.image?.imageBig = newValue!.jpegData(compressionQuality: 1)
                self.imageSmall = newValue!.jpegData(compressionQuality: 0.05)
            }
            dateUpdate = Date()
        }
        
        get {
            if self.image != nil {
                if self.image?.imageBig != nil {
                    return UIImage(data: self.image!.imageBig!)
                }
            }
            return nil
        }
    }
    
    var locationActual: LocationCoordinate? {
        get {
            guard let location = self.location else {return nil}
            return LocationCoordinate(latitude: location.latitude, longitude: location.longitude)
        }
        set {
            if newValue == nil && self.location == nil {
                /// удалить локацию
                CoreDataManager.sharedInstance.managedObjectContext.delete(self.location!)
            } else if newValue != nil && self.location != nil {
                /// обновить локацию
                self.location?.latitude = newValue!.latitude
                self.location?.longitude = newValue!.longitude
            } else if newValue != nil && self.location == nil {
                /// создать локацию
                let newLocation = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
                newLocation.latitude = newValue!.latitude
                newLocation.longitude = newValue!.longitude
                self.location = newLocation
            }
        }
    }
    
    func addCurrentLocation() {
        LocationManager.sharedInstance.getCurrentLocation { (location) in
            self.locationActual = location
            print("Получили новую локацию: \(location)")
        }
    }
    
    func addImage(image: UIImage) {
        let imageNote = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
        
        imageNote.imageBig = image.jpegData(compressionQuality: 1)
        self.image = imageNote
    }
    
    func addLocation(latitude: Double, longitude: Double) {
        let location = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
        location.latitude = latitude
        location.longitude = longitude
        
        self.location = location
    }
}
