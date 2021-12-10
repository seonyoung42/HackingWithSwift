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
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
//        locationManager?.requestWhenInUseAuthorization()
        
        view.backgroundColor = .gray
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
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
//        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        locationManager?.startRangingBeacons(in: beaconRegion)
    
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
//            case .unknown:
//                self.view.backgroundColor = .gray
//                self.distantReading.text = "UNKNOWN"
            case .far:
                self.view.backgroundColor = .blue
                self.distantReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distantReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distantReading.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = .gray
                self.distantReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}

