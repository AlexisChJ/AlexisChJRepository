//
//  MapView.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 13/10/24.
//

import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    var projectsList: [Projects] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                let welcome = try await WelcomeJSON2.fetchProjectsJSON()
                self.actualizarUI(p: welcome)
            } catch {
                print("Error fetching projects: \(ProjectsJSONError.notConnected)")
            }
        }
    }
    
    func actualizarUI(p: Welcome2) {
        Task {
            self.projectsList = p.projects
            self.configureMap()
            self.addPins()
        }
    }
    
    private func configureMap() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        
        let initialCoordinate = CLLocationCoordinate2D(latitude: 32.7830600, longitude: -96.8066700)
        let span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
        let region = MKCoordinateRegion(center: initialCoordinate, span: span)
        
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
        
        mapView.delegate = self
    }
    
    
    private func addPins() {
        var annotations: [MKPointAnnotation] = []
        for project in projectsList {
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: project.latitude, longitude: project.longitude)
            pin.title = project.title
            pin.subtitle = project.description
            annotations.append(pin)
            mapView.addAnnotation(pin)
        }
        mapView.showAnnotations(annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "customPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .systemGreen
            annotationView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
