import Foundation

struct WeatherForecastFiveDays: Codable {
    let city: Name
    var list: [List?]
}

struct Name: Codable {
    let name: String?
}

struct List: Codable {
    let dt: Int?
    let main: Temp
    let weather: [WeatherMain]
}

struct Temp: Codable {
    let temp: Double?
}

struct WeatherMain: Codable {
    let description: String?
    let icon: String?
}
