//
//  ViewController.swift
//  MapKitLab
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
//TODO: Fix
    
    @IBOutlet weak var mapView: MKMapView!
      private let locationSession = CoreLocationSession()
    public var schools = [NYSchools]()
    private var isShowingAnnotations = false
    private var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
        loadMapView()
        api()
     
    }
    func api() {
        APIClient.getSchools { [weak self] (result) in
            switch result {
            case .failure(let appError):
               print("print")
            case .success(let school):
                DispatchQueue.main.async {
                    //this result make annotations is unused
                    self?.schools = school
                    self?.makeAnnotations()
                }
            }
        }
    }
    
    func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        //we will go through the array of annotations and make annotation and the min needs a coordinate
        for location in schools {
            let annotation = MKPointAnnotation()
            //TODO: CLLocation
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(location.latitude) as! CLLocationDegrees, longitude: Double(location.longitude) as! CLLocationDegrees)
            annotation.title = location.schoolName
            annotations.append(annotation)
        }
        return annotations
    }
    private func loadMapView() {
         let annotations = makeAnnotations()
         mapView.addAnnotations(annotations)
         //This will zoom in and show as many annotations as you can on the mapview. So it is a more zoomed result
         mapView.showAnnotations(annotations, animated: true)
     }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect")
    }
    //another method that can get called //this is like a cell for row at but for mapkit //MARK: 12:47
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else {
        return nil
    }
    //if it does exist we will use it if not we will make a new one and the identifier  string only matters when you delete it
    let identifier = "locationAnnotation"
    var annotationView: MKPinAnnotationView
    ///try to deque and reuse annotation view
    if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
        annotationView = dequeueView
    } else {
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.canShowCallout = true
    }
    return annotationView
  }
    //this makes the annotations(pins) bubble up when hovering over with your cursor
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
   
    
}
