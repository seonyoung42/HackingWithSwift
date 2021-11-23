//
//  ViewController.swift
//  Project16
//
//  Created by 장선영 on 2021/11/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2021 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        
        mapView.addAnnotations([london,oslo,paris,rome,washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "mapType", style: .plain, target: self, action: #selector(chooseMapType))
        
    }
    
    @objc func chooseMapType() {
        let ac = UIAlertController(title: "MapTyle", message: "you can choose a mapType", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "hybrid", style: .default, handler: { _ in
            self.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "mutedStandard", style: .default, handler: { _ in
            self.mapView.mapType = .mutedStandard
        }))
        ac.addAction(UIAlertAction(title: "satellite", style: .default, handler: { _ in
            self.mapView.mapType = .satellite
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        
        if let pinAnnotation = annotationView as? MKPinAnnotationView {
            pinAnnotation.pinTintColor = .blue
        }
        
        
        return annotationView
        
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info

        
        if let destination = storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController {
            destination.cityName = placeName
            navigationController?.pushViewController(destination, animated: true)
        } else {
            let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
            ac.addAction((UIAlertAction(title: "OK", style: .default, handler: nil)))
            present(ac, animated: true, completion: nil)
        }
    }

}

