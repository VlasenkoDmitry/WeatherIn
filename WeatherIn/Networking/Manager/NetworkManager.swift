import Foundation
import UIKit

struct NetworkManager {
    
    
    func getCurrent(lat: String,lon: String, language: String, onCompletion: @escaping (WeatherToday?, String?) -> ()) {
        let parametrs: Parameters = ["lat": lat, "lon": lon]
        APIRequestManager.makeGetRequest( type: .current, coordinates: parametrs,language: language) { (result: WeatherToday?, error) in
            if let error = error {
                print("Get current - ", error)
            }
            onCompletion(result, error)
        }
    }
    
    func getFiveDays(lat: String,lon: String, language: String, onCompletion: @escaping (WeatherForecastFiveDays?, String?) -> ()) {
        let parametrs: Parameters = ["lat": lat, "lon": lon]
        APIRequestManager.makeGetRequest(type: .fiveDays, coordinates: parametrs, language: language) { (result: WeatherForecastFiveDays?, error) in
            if let error = error {
                print("Get five days - ", error)
            }
            onCompletion(result, error)
        }
    }
    
    func getImage(name: String, completion: @escaping (Data?,Error?) -> ()) {
        APIRequestManager.makeGetImage(name: name) { data, error in
            if let error = error {
                print("Get image error - ", error)
            }
            completion(data,error)
        }
    }
}

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

func handleNetworkResponse(response: HTTPURLResponse) -> Result<String>{
    switch response.statusCode {
    case 200...299: return .success
    case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
    case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
    case 600: return .failure(NetworkResponse.outdated.rawValue)
    default: return .failure(NetworkResponse.failed.rawValue)
    }
}

enum NetworkError : String, Error {
    case missingURL = "URL is nil."
}

typealias PackageData = (weatherToday: WeatherToday?, weatherForecast: WeatherForecastFiveDays?, imageWeatherToday: UIImage?, imagesWeatherForecast: [UIImage?]?)

typealias Parameters = [String : Any]

enum Result<String>{
    case success
    case failure(String)
}
