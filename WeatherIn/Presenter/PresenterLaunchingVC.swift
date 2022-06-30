import Foundation
import CoreLocation
import UIKit

class PresenterLaunchingVC {
    private var weatherForecast: WeatherForecastFiveDays?
    private var weatherToday: WeatherToday?
    private var imagesWeatherForecast: [UIImage?] = []
    private var imageWeatherToday: UIImage?
    weak private var viewOutputDelegate: ViewOutputDelegateLaunchingVC?
    private var newError: String?
    private let networkManager = NetworkManager()
    private var locationManager = LocationManager()
    private let languageApp = Locale.current.languageCode
    
    func setViewOutputDelegate(viewOutputDelegate:ViewOutputDelegateLaunchingVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
    
    //loading object class LocationManager and finding coordinates. Delegate is for beginning download data
    private func locationDetermination() {
        locationManager.delegate = self
        locationManager.locationDetermination()
    }
    
    //function to start download data after finding coordinates
    private func downloadAllData(lat: String, lon: String) {
        guard let language = languageApp else { return }
        loadData(lat: lat, lon: lon, language: language, completion: { package,error in
            if error == nil {
                let presenter = PresenterMainVC(weatherToday: package?.weatherToday, weatherForecast:  package?.weatherForecast, imageWeatherToday:  package?.imageWeatherToday, imageWeatherForecast:  package?.imagesWeatherForecast)
                self.viewOutputDelegate?.initializeTabBarController(presenter: presenter)
            }
        })
    }
    
    private func loadData(lat: String, lon: String, language: String, completion: @escaping (PackageData?,String?)->()) {
        //to synchronize download data use DispatchGroup
        let loadingForecastsGroup = DispatchGroup()
        
        loadingForecastsGroup.enter()
        networkManager.getFiveDays(lat: lat, lon: lon, language: language) { result, error in
            if error == nil && result != nil {
                self.weatherForecast = result
                guard let list = result?.list else { return }
                self.imagesWeatherForecast = Array(repeating: nil, count: list.count)
                let semaphore = DispatchSemaphore(value: 1)
                for (index, element) in list.enumerated() {
                    loadingForecastsGroup.enter()
                    guard let icon = element?.weather[0].icon else { return }
                    self.networkManager.getImage(name: icon) { [weak self] imageData, error in
                        semaphore.wait()
                        if let imageData = imageData {
                            self?.imagesWeatherForecast[index] = UIImage(data: imageData)                           
                        } else {
                            self?.imagesWeatherForecast[index] = nil
                        }
                        semaphore.signal()
                        loadingForecastsGroup.leave()
                    }
                }
            } else {
                self.newError = error
            }
            loadingForecastsGroup.leave()
        }
        
        loadingForecastsGroup.enter()
        networkManager.getCurrent(lat: lat, lon: lon, language: language) { result, error in
            if error == nil && result != nil {
                self.weatherToday = result
                print("Current")
                guard let name = result?.weather[0].icon else { return }
                loadingForecastsGroup.enter()
                self.networkManager.getImage(name: name) {[weak self] imageData,error in
                    if let imageData = imageData {
                        self?.imageWeatherToday = UIImage(data: imageData)
                        print(imageData)
                    } else {
                        self?.imageWeatherToday = nil
                    }
                    print("FirstImage")
                    loadingForecastsGroup.leave()
                }
            } else {
                self.newError = error
            }
            loadingForecastsGroup.leave()
        }

        loadingForecastsGroup.notify(queue: .main) {
            if let newError = self.newError {
                completion(nil,newError)
            } else {
            let packageData = PackageData(self.weatherToday,self.weatherForecast,self.imageWeatherToday,self.imagesWeatherForecast)
            completion(packageData,nil)
            }
        }
    }
}

//extension to begin find location (delegate LaunchingVC)
extension PresenterLaunchingVC: ViewInputDelegateLaunchingVC {
    func beginLocationDetermination() {
        locationDetermination()
    }
}

//extension for download data after finding coordinates in class LocationManager
extension PresenterLaunchingVC: LocationManagerDelegate {
    func downloadData(lat: String, lon: String) {
        downloadAllData(lat: lat, lon: lon)
    }
}
