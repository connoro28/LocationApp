import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var trackedLocations: [TrackedLocation] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.6516, longitude: -82.3248),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    // Get the unique ID for the current device.
    private let myDeviceID = UIDevice.current.identifierForVendor?.uuidString

    // A computed property to calculate and format the distance.
    private var distanceText: String? {
        // Only calculate if there are exactly two locations.
        guard trackedLocations.count == 2 else { return nil }
        
        let location1 = CLLocation(latitude: trackedLocations[0].latitude, longitude: trackedLocations[0].longitude)
        let location2 = CLLocation(latitude: trackedLocations[1].latitude, longitude: trackedLocations[1].longitude)
        
        // Calculate distance in meters.
        let distanceInMeters = location1.distance(from: location2)
        
        // Use a formatter for a clean, localized string (e.g., "1.2 miles").
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        
        let measurement = Measurement(value: distanceInMeters, unit: UnitLength.meters)
        return formatter.string(from: measurement.converted(to: .miles))
    }

    var body: some View {
        // Use a ZStack to overlay the distance text on top of the map.
        ZStack {
            MapReader { proxy in
                Map(coordinateRegion: $region, annotationItems: trackedLocations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        // Check if the location's userID matches our device's ID.
                        if location.userID == myDeviceID {
                            // My Pin (Red)
                            Circle()
                                .strokeBorder(.red, lineWidth: 2)
                                .background(Circle().fill(.white))
                                .frame(width: 20, height: 20)
                        } else {
                            // Other User's Pin (Blue)
                            Circle()
                                .strokeBorder(.blue, lineWidth: 2)
                                .background(Circle().fill(.white))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // This VStack positions the distance text at the bottom.
            VStack {
                Spacer()
                if let distance = distanceText {
                    Text("Distance: \(distance)")
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                }
            }
        }
        .onAppear {
            fetchLocations()
        }
    }
    
    private func fetchLocations() {
        let db = Firestore.firestore()
        db.collection("locations").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.trackedLocations = documents.compactMap { document in
                try? document.data(as: TrackedLocation.self)
            }
        }
    }
}

#Preview {
    ContentView()
}
