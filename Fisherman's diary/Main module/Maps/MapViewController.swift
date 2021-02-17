//
//  MapViewController.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 04.02.2021.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet private var mapView: MKMapView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let mapLongTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        mapView.addGestureRecognizer(mapLongTapGestureRecognizer)
    }
    
    //MARK: - Actions
    
    @objc private func handleLongTap(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        
        let point = recognizer.location(in: mapView)
        
        let convertPoint = mapView.convert(point, toCoordinateFrom: mapView)
        
        let newNote = Note.newNote(name: "", inFolder: nil)
        newNote.locationActual = LocationCoordinate(latitude: convertPoint.latitude, longitude: convertPoint.longitude)
        
        goToNoteVC(note: newNote)
    }

    
    private func showPics() {
        for note in Storage.notes {
            if note.locationActual != nil {
                mapView.addAnnotation(NoteAnnotation(note: note))
                
            }
        }
    }
    
    private func goToNoteVC(note: Note) {
        
        let noteTableVC = storyboard?.instantiateViewController(identifier: "noteSID") as! NoteTableViewController
        noteTableVC.note = note
        navigationController?.pushViewController(noteTableVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mapView.removeAnnotations(mapView.annotations)
        showPics()
    }
    
    
    
}

//MARK: - Extentsions

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            DispatchQueue.main.async {
                mapView.setCenter(annotation.coordinate, animated: true)
            }
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let selectedNote = (view.annotation as! NoteAnnotation).note
        goToNoteVC(note: selectedNote)
    }
}
