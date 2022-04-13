import Foundation

class LinkLoadingWeather {
    static var urlParameters = [
        "lat": "0",
        "lon": "0",
        "units": "metric",
        "appid": "81c0ddde4f4781d0525d8fdf1c1683d4"
    ]
    
    func getURL(_ url: String) -> URL? {
        var components = URLComponents(string: url)
        components?.queryItems = LinkLoadingWeather.urlParameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        return components?.url
    }
    
    func changeParametrs(lon: String, lat: String) {
        LinkLoadingWeather.urlParameters["lon"] = lon
        LinkLoadingWeather.urlParameters["lat"] = lat
    }
}
