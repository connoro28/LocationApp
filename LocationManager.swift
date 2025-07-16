import Foundation
import CoreLocation // The framework for all location services
import Combine // Used for the @Published property
import FirebaseFirestore
import UIKit

// This class will manage location updates.
// It's an ObservableObject so SwiftUI views can watch it for changes.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // The core object from CoreLocation that does the work.
    private let locationManager = CLLocationManager()
    
    // We will publish the user's location so any view can access it.
    // The 'Published' property wrapper is from the Combine framework.
    @Published var lastKnownLocation: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Tell the location manager to allow background updates.
        self.locationManager.allowsBackgroundLocationUpdates = true
        
        // Request "Always" permission instead of "When In Use".
        self.locationManager.requestAlwaysAuthorization()
    }
    
    // This is a required delegate method that gets called when the user
    // allows or denies permission.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            // Permission granted, start updating the location.
            manager.startUpdatingLocation()
        } else {
            // Permission denied. Handle this case, e.g., show an alert.
            print("Location permission denied.")
        }
    }

    // This delegate method is called whenever a new location update is received.
    // Add this import to get access to UIDevice

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.last
        
        guard let location = locations.last else { return }
        
        // Get a unique identifier for this device.
        // This acts as our temporary user ID.
        guard let userID = UIDevice.current.identifierForVendor?.uuidString else {
            print("Could not get a unique ID for this device.")
            return
        }
        
        let db = Firestore.firestore()
        
        // Add the userID to the data we send.
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": FieldValue.serverTimestamp(),
            "userID": userID
        ]
        
        db.collection("locations").addDocument(data: locationData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written with userID!")
            }
        }
    }
    
    // This delegate method is called if the location manager encounters an error.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
