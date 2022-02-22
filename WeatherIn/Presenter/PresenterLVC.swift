import Foundation
import CoreLocation
import UIKit

class PresenterLVC: NSObject,CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var dataFiveDays: WeatherFiveDays?
    var dataCurrent: WeatherCurrent?
    var arrayImages: [UIImage?] = []
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
        let loadingForecastsGroup = DispatchGroup()
        loadingForecastsGroup.enter()
        Download.shared.requestWeather(typeRequest: .FiveDays, lat: lat, lon: lon) { [self] data, error in
            guard let data = data else { return }
            self.dataFiveDays = JSONParser().decode(data: data, classRequest: WeatherFiveDays.self)
            print("FiveDays")
            
            guard let list = self.dataFiveDays?.list else {return}
            arrayImages = Array(repeating: nil, count: list.count)
            let semaphore = DispatchSemaphore(value: 1)
            for (index,element) in list.enumerated() {
                loadingForecastsGroup.enter()
                guard let icon = element?.weather[0].icon else {return}
                Download.shared.requestImage(name: icon) { [self] imageData in
                    semaphore.wait()
                    guard let image = UIImage(data: imageData) else {return}
                    print(index)
                    arrayImages[index] = image
                    loadingForecastsGroup.leave()
                    semaphore.signal()
                }
            }
            loadingForecastsGroup.leave()
            
        }

        loadingForecastsGroup.enter()
        Download.shared.requestWeather(typeRequest: .Current, lat: lat, lon: lon) { data, error in
            guard let data = data else { return }
            self.dataCurrent = JSONParser().decode(data: data, classRequest: WeatherCurrent.self)
            print("Current")
            
            guard let name = self.dataCurrent?.weather[0].icon else { return }
            loadingForecastsGroup.enter()
            Download.shared.requestImage(name: name) { imageData in
                self.imageWeatherNow = UIImage(data: imageData)
                print("FirstImage")
                loadingForecastsGroup.leave()
            }
            loadingForecastsGroup.leave()
        }
        
        loadingForecastsGroup.wait()
        
        loadingForecastsGroup.notify(queue: .main) {
            guard let dataCurrent = self.dataCurrent else { return  }
            guard let dataFiveDays = self.dataFiveDays else { return  }
            let presenter = PresenterMC(dataCurrent: dataCurrent, dataFiveDays: dataFiveDays,imageWeatherNow: self.imageWeatherNow, arrayImages: self.arrayImages)
            self.viewInputDelegate?.initializeTabBarController(presenter: presenter)
        }
        
    }
}

extension PresenterLVC: ViewOutputDelegateMC {
    func beginLocationDetermination() {
        locationDetermination()
    }
    
    
}
