import Foundation
import CoreLocation
import UIKit

class PresenterLVC: NSObject,CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var dataFiveDays: WeatherFiveDays?
    var dataCurrent: WeatherCurrent?
    var arrayImages: [UIImage] = []
    var imageWeatherNow: UIImage?
    weak private var viewInputDelegate: ViewInputDelegateMC?
    
    func setViewInputDelegate(viewInputDelegate:ViewInputDelegateMC?) {
        self.viewInputDelegate = viewInputDelegate
    }
    
    func locationDetermination() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager : CLLocationManager, didUpdateLocations locations : [CLLocation]) {
        let location:CLLocationCoordinate2D = manager.location!.coordinate
        print("lat: \(location.latitude), lon \(location.longitude)")
        locationManager.stopUpdatingLocation()
        
        let lat = String(location.latitude)
        let lon = String(location.longitude)
        loadData(lat: lat, lon: lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: ", error)
        print("Turn on geolocation")
    }
    
    func loadData(lat: String, lon: String) {

    }
}

extension PresenterLVC: ViewOutputDelegateMC {
    func beginLocationDetermination() {
        locationDetermination()
    }
}
