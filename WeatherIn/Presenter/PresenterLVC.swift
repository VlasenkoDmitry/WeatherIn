import Foundation
import CoreLocation
import UIKit

class PresenterLVC: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var dataFiveDays: WeatherFiveDays?
    private var dataCurrent: WeatherCurrent?
    private var arrayImages: [UIImage?] = []
    private var imageWeatherNow: UIImage?
    weak private var viewInputDelegate: ViewInputDelegateMC?
    private var newError: Error?
    func setViewInputDelegate(viewInputDelegate:ViewInputDelegateMC?) {
        self.viewInputDelegate = viewInputDelegate
    }
    
    private func locationDetermination() {
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
        
        do {
            try loadData(lat: lat, lon: lon)
        } catch let myError {
            guard let myError = myError as? LoadingErrors else { return }
            if myError == LoadingErrors.loadDataError {
                viewInputDelegate?.showAlertError(title: "", text: "There is a problem with loading data. Check the connection")
            }
            if myError == LoadingErrors.jsonParseError {
                viewInputDelegate?.showAlertError(title: "", text: "Problem with data processing")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Not Determined")
        case .restricted, .denied:
            print("Restricted or denied")
            viewInputDelegate?.showAlertError(title: "", text: "App does not work without geolocation")
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
    //                    dataError.localizedDescription = "problem with data processing "
    private func loadData(lat: String, lon: String) throws {
        let loadingForecastsGroup = DispatchGroup()
        loadingForecastsGroup.enter()
        Download.shared.requestWeather(typeRequest: .FiveDays, lat: lat, lon: lon) { [weak self] newResult in
            switch newResult {
            case .success(let data):
                self?.dataFiveDays = JSONParser().decode(data: data, classRequest: WeatherFiveDays.self)
                if self?.dataFiveDays == nil {
                    var dataError: Error
                    self?.newError = LoadingErrors.jsonParseError
                    break
                }
                print("FiveDays")
                guard let list = self?.dataFiveDays?.list else { return }
                self?.arrayImages = Array(repeating: nil, count: list.count)
                let semaphore = DispatchSemaphore(value: 1)
                for (index, element) in list.enumerated() {
                    loadingForecastsGroup.enter()
                    guard let icon = element?.weather[0].icon else { return }
                    Download.shared.requestImage(name: icon) { [weak self] imageData in
                        semaphore.wait()
                        if let imageData = imageData {
                            self?.arrayImages[index] = UIImage(data: imageData)
                        } else {
                            self?.arrayImages[index] = nil
                        }
                        semaphore.signal()
                        loadingForecastsGroup.leave()
                    }
                }
            case .failure(let error):
                self?.newError = LoadingErrors.loadDataError
            }
            loadingForecastsGroup.leave()
        }
        
        loadingForecastsGroup.enter()
        Download.shared.requestWeather(typeRequest: .Current, lat: lat, lon: lon) { [weak self] newResult in
            switch newResult {
            case .success(let data):
                self?.dataCurrent = JSONParser().decode(data: data, classRequest: WeatherCurrent.self)
                if self?.dataCurrent == nil {
                    self?.newError = LoadingErrors.jsonParseError
                    break
                }
                print("Current")
                guard let name = self?.dataCurrent?.weather[0].icon else { return }
                loadingForecastsGroup.enter()
                Download.shared.requestImage(name: name) { [weak self] imageData in
                    if let imageData = imageData {
                        self?.imageWeatherNow = UIImage(data: imageData)
                    } else {
                        self?.imageWeatherNow = nil
                    }
                    print("FirstImage")
                    loadingForecastsGroup.leave()
                }
            case .failure(let error):
                self?.newError = LoadingErrors.loadDataError
            }
            loadingForecastsGroup.leave()
        }
        
        loadingForecastsGroup.wait()
        if let newError = newError {
            throw newError
        }
        loadingForecastsGroup.notify(queue: .main) {
            guard let dataCurrent = self.dataCurrent else { return  }
            guard let dataFiveDays = self.dataFiveDays else { return  }
            let presenter = PresenterMC(dataCurrent: dataCurrent, dataFiveDays: dataFiveDays, imageWeatherNow: self.imageWeatherNow, arrayImages: self.arrayImages)
            self.viewInputDelegate?.initializeTabBarController(presenter: presenter)
        }
        
    }
}

extension PresenterLVC: ViewOutputDelegateMC {
    func beginLocationDetermination() {
        locationDetermination()
    }
}

