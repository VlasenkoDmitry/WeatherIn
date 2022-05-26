import Foundation
import CoreLocation
import UIKit

protocol LocationManagerDelegate: AnyObject {
    func downloadData(lat: String, lon: String)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    func locationDetermination() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager : CLLocationManager, didUpdateLocations locations : [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        print("lat: \(location.latitude), lon \(location.longitude)")
        locationManager.stopUpdatingLocation()
        let lat = String(location.latitude)
        let lon = String(location.longitude)
        delegate?.downloadData(lat: lat, lon: lon)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Not Determined")
        case .restricted, .denied:
            print("Restricted or denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
        default:
            print("Unknown status location manager")
        }
        switch error._code {
        case 1:
            print("User denied access to the location service")
        case 0:
            print("Location manager was unable to obtain a location value right now")
        case 3:
            print("Location manager can’t determine the heading")
        default:
            print("Unknown error")
        }
    }
}

