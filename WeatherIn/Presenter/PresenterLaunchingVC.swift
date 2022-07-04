import Foundation
import CoreLocation
import UIKit

class PresenterLaunchingVC {
    private let networkManager = NetworkManager()
    private let locationManager = LocationManager()
    private let languageApp = Locale.current.languageCode
    private let loadingWeatherGroup = DispatchGroup()
    private var weatherForecast: WeatherForecastFiveDays?
    private var weatherToday: WeatherToday?
    private var imagesWeatherForecast: [UIImage?] = []
    private var imageWeatherToday: UIImage?
    private var newError: String?
    weak private var viewOutputDelegate: ViewOutputDelegateLaunchingVC?
    
    func setViewOutputDelegate(viewOutputDelegate:ViewOutputDelegateLaunchingVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
    
    private func locationDetermination() {
        locationManager.delegate = self
        locationManager.locationDetermination()
    }
    
    private func downloadWeatherByCoordinates(lat: String, lon: String) {
        guard let language = languageApp else { return }
        loadData(lat: lat, lon: lon, language: language, completion: { [weak self] package, error in
            if let package = package, error == nil {
                let presenter = PresenterMainVC(weatherToday: package.weatherToday, weatherForecast:  package.weatherForecast, imageWeatherToday:  package.imageWeatherToday, imageWeatherForecast: package.imagesWeatherForecast)
                self?.viewOutputDelegate?.displayMainVC(presenter: presenter)
            }
        })
    }
    
    private func loadData(lat: String, lon: String, language: String, completion: @escaping (PackageWeatherData?,String?)->()) {
        //to synchronize download data use DispatchGroup
        loadingWeatherGroup.enter()
        networkManager.getFiveDays(lat: lat, lon: lon, language: language) { [weak self] result, error in
            self?.processLoadingFiveDays(result: result, error: error)
            self?.loadingWeatherGroup.leave()
        }
        
        loadingWeatherGroup.enter()
        networkManager.getCurrent(lat: lat, lon: lon, language: language) { [weak self] result, error in
            self?.processLoadingCurrent(result: result, error: error)
            self?.loadingWeatherGroup.leave()
        }

        loadingWeatherGroup.notify(queue: .main) {
            if let newError = self.newError {
                completion(nil,newError)
            } else {
                let packageWeatherData = PackageWeatherData(self.weatherToday, self.weatherForecast, self.imageWeatherToday, self.imagesWeatherForecast)
                completion(packageWeatherData,nil)
            }
        }
    }
    
    private func processLoadingFiveDays(result: WeatherForecastFiveDays?, error: String?) {
        if error == nil && result != nil {
            self.weatherForecast = result
            guard let list = result?.list else { return }
            self.imagesWeatherForecast = Array(repeating: nil, count: list.count)
            let semaphore = DispatchSemaphore(value: 1)
            for (index, element) in list.enumerated() {
                loadingWeatherGroup.enter()
                guard let icon = element?.weather[0].icon else { return }
                self.networkManager.getImage(name: icon) { [weak self] imageData, error in
                    semaphore.wait()
                    if let imageData = imageData {
                        self?.imagesWeatherForecast[index] = UIImage(data: imageData)
                    } else {
                        self?.imagesWeatherForecast[index] = nil
                    }
                    semaphore.signal()
                    self?.loadingWeatherGroup.leave()
                }
            }
        } else {
            self.newError = error
        }
    }
    
    private func processLoadingCurrent(result: WeatherToday?, error: String?) {
        if error == nil && result != nil {
            self.weatherToday = result
            print("Current")
            guard let name = result?.weather[0].icon else { return }
            self.loadingWeatherGroup.enter()
            self.networkManager.getImage(name: name) { [weak self] imageData,error in
                if let imageData = imageData {
                    self?.imageWeatherToday = UIImage(data: imageData)
                    print(imageData)
                } else {
                    self?.imageWeatherToday = nil
                }
                print("FirstImage")
                self?.loadingWeatherGroup.leave()
            }
        } else {
            self.newError = error
        }
    }
}

extension PresenterLaunchingVC: ViewInputDelegateLaunchingVC {
    func beginLocationDetermination() {
        locationDetermination()
    }
}

//download data after finding coordinates in class LocationManager
extension PresenterLaunchingVC: LocationManagerDelegate {
    func downloadData(lat: String, lon: String) {
        downloadWeatherByCoordinates(lat: lat, lon: lon)
    }
}
