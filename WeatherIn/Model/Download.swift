import Foundation
import UIKit

class Download {
    static let shared = Download()
    
    func requestWeather (typeRequest request: TypeRequest,
                  lat: String,
                  lon: String,
                  completion: @escaping (Data?, Error?) -> ()) {
        LinkLoadingWeather.shared.changeParametrs(lon: lon,lat: lat)
        guard let url = LinkLoadingWeather.shared.getURL(request.rawValue) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if error == nil, let data = data {
                completion(data, error)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func requestImage(name: String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string:"http://openweathermap.org/img/wn/"+"\(name)"+"@2x.png") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
            guard let data = data , error == nil else { return }
            completion(data)
        }).resume()
    }
}
