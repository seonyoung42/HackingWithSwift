//
//  ViewController.swift
//  Project 22
//
//  Created by 장선영 on 2021/12/10.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distantReading: UILabel!
    @IBOutlet var circleImageView: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var showAlert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        circleImageView.layer.cornerRadius = 128 // make imageView circle
        circleImageView.tintColor = .black
        self.circleImageView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        
        view.backgroundColor = .yellow
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        
        addBeaconRegion(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "Apple Airlocate")
        addBeaconRegion(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6", major: 123, minor: 456, identifier: "Radius Networks")
        addBeaconRegion(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491", major: 123, minor: 456, identifier: "TwoCanoes")
    }
    
    func addBeaconRegion(uuidString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
        let uuid = UUID(uuidString: uuidString)!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
            
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        }
    
    
    func update(distance: CLProximity, location: String) {
        UIView.animate(withDuration: 1) {
            
            self.locationLabel.text = location
            
            switch distance {
//            case .unknown:
//                self.view.backgroundColor = .gray
//                self.distantReading.text = "UNKNOWN"
            case .far:
                self.view.backgroundColor = .blue
                self.distantReading.text = "FAR"
                self.circleImageView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = .orange
                self.distantReading.text = "NEAR"
                self.circleImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = .red
                self.distantReading.text = "RIGHT HERE"
                self.circleImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            default:
                self.view.backgroundColor = .gray
                self.distantReading.text = "UNKNOWN"
                self.circleImageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity, location: region.identifier)
            
            if showAlert == false {
                let ac = UIAlertController(title: "Detect Beacon", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
                showAlert = true
            }
        } else {
            update(distance: .unknown, location: "unknown")
        }
    }
}

