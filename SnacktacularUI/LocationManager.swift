//
//  LocationManager.swift
//  LocationAndPlaceLookup
//
//  Created by Zimeng Yang on 3/28/26.
//

import Foundation
import MapKit

@Observable

class LocationManager: NSObject, CLLocationManagerDelegate {
    var location: CLLocation?
    private let locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var errorMessage: String?
    var locationUpdated: ((CLLocation) -> Void)? // this is a func that can be called, passing in a location
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Get a region around current location with specified radius in meters
    func getRegionAroundCurrentLocation(radiusInMeters: CLLocationDistance = 10000) -> MKCoordinateRegion? {
        guard let location = location else { return nil }
        return MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radiusInMeters,
            longitudinalMeters: radiusInMeters
        )
    }
}

// Delegate methods that Apple has created & will call, but that we filled out
extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        location = newLocation
        // Call the callback func to indicate we've update a location
        locationUpdated?(newLocation)
        // if you only want to get the location once
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("LocationManager authorization granted.")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("LocationManager authorization denied.")
            errorMessage = "😡📍 LocationManager authorization denied."
            manager.stopUpdatingLocation()
        case .notDetermined:
            print("LocationManager authorization is not determined.")
            manager.requestWhenInUseAuthorization()
        @unknown default:
            print("Look for New eNum for CLLocationManager.AuthorizationStatus!")
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessage = error.localizedDescription
        print("😡 ERROR LocationManager: \(errorMessage ?? "n/a")")
    }
}

