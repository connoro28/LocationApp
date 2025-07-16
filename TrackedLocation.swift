//
//  TrackedLocation.swift
//  LocationTracker
//
//  Created by Opdyke, Connor L. on 7/15/25.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift // Import this to use @DocumentID
import CoreLocation

struct TrackedLocation: Identifiable, Codable {
    
    // This property wrapper tells Firestore to map the document's ID here.
    @DocumentID var id: String?
    
    var latitude: Double
    var longitude: Double
    var userID: String
    
    // We make this optional because it might not exist on old documents.
    var timestamp: Timestamp?
    
    // A computed property to easily get a CLLocationCoordinate2D
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
