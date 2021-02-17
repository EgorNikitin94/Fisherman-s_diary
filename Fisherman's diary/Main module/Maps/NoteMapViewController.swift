//
//  NoteMapViewController.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 04.02.2021.
//

import UIKit
import MapKit

final class NoteMapViewController: UIViewController {
    
    //MARK: - Properties
    
    var note: Note?
    
    @IBOutlet private var noteMap: MKMapView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteMap.delegate = self
        
        if note?.locationActual != nil {
            noteMap.addAnnotation(NoteAnnotation(note: note!))
            noteMap.centerCoordinate = CLLocationCoordinate2D(latitude: note!.locationActual!.latitude, longitude: note!.locationActual!.longitude)
        }
        
        let mapLongTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        noteMap.addGestureRecognizer(mapLongTapGestureRecognizer)
    }
    
    //MARK: - Actions
    
    @objc private func handleLongTap(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        
        let point = recognizer.location(in: noteMap)
        
        let convertPoint = noteMap.convert(point, toCoordinateFrom: noteMap)
        
        note?.locationActual = LocationCoordinate(latitude: convertPoint.latitude, longitude: convertPoint.longitude)
        
        CoreDataManager.sharedInstance.saveContext()
        
        noteMap.removeAnnotations(noteMap.annotations)
        noteMap.addAnnotation(NoteAnnotation(note: note!))
    }

}

//MARK: - Extensions

extension NoteMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.isDraggable = true
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        if newState == .ending {
            let newLocation = LocationCoordinate(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
            
            note?.locationActual = newLocation
            CoreDataManager.sharedInstance.saveContext()
        }
    }
}
