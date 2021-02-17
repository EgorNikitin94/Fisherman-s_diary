//
//  NoteAnnotation.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 04.02.2021.
//

import Foundation
import MapKit

final class NoteAnnotation: NSObject, MKAnnotation {
    
    //MARK: - Properties
    
    var note: Note
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?

    var subtitle: String?
    
    //MARK: - Init
    
    init(note: Note) {
        self.note = note
        title = note.name
        
        if note.locationActual != nil {
            coordinate = CLLocationCoordinate2D(latitude: note.locationActual!.latitude, longitude: note.locationActual!.longitude)
        } else {
            coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}
