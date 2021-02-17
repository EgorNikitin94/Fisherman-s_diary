//
//  Location+CoreDataProperties.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 28.01.2021.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var note: Note?

}

extension Location : Identifiable {

}
