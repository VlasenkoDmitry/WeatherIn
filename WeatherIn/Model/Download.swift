import Foundation
import UIKit

class Download {
    private var linkLoadingWeather = LinkLoadingWeather()
    
    func requestWeather (typeRequest request: TypeRequest,
                         lat: String,
                         lon: String,
                         completion: @escaping (Result<Data, Error>) -> Void) {
        linkLoadingWeather.changeParametrs(lon: lon, lat: lat)
        guard let url = linkLoadingWeather.getURL(request.rawValue) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if data != nil, error == nil {
                completion(.success(data!))
            } else {
                completion(.failure(error!))
            }
        }
        task.resume()
    }
    
    func requestImage(name: String, completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: "http://openweathermap.org/img/wn/"+"\(name)"+"@2x.png") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
            completion(data)
        }).resume()
    }
}
