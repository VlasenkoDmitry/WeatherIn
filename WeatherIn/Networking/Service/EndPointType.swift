import Foundation

protocol EndPointType {
    var apiKeyWeather: String { get }
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var systemAdditionalParameters: Parameters { get }
}
