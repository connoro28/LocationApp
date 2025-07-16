import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

struct TrackedLocation: Identifiable, Codable {
    
    // This property wrapper tells Firestore to map the document's ID here.
    @DocumentID var id: String?
    
    var latitude: Double
    var longitude: Double
    var userID: String
    
    var timestamp: Timestamp?
    
    // A computed property to easily get a CLLocationCoordinate2D
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
