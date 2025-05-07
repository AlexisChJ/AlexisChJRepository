//
//  DashboardDetail.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 07/10/24.
//

import UIKit
import MapKit

class DashboardDetail: UIViewController {
    var dashboard: Projects?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var TitleDashboard: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var content: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleDashboard.layer.shadowColor = UIColor.darkGray.cgColor
        TitleDashboard.layer.shadowOpacity = 0.5
        TitleDashboard.layer.shadowOffset.width = .zero
        TitleDashboard.layer.shadowOffset.height = 4
        
        locationLabel.addLine(position: .bottom, color: .lightGray, width: 1.0)
        
        image.makeRounded()
        if let dashboard = dashboard{
            let initialLocation = CLLocation(latitude: dashboard.latitude, longitude: dashboard.longitude)
            mapView.centerToLocation(initialLocation)
            
            let ImageURL = URL(string: dashboard.imageLink)
            image.load(url: ImageURL!)
            
            locationLabel.text = dashboard.location
            TitleDashboard.text = dashboard.title
            content.text = dashboard.description
        }
    }
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
