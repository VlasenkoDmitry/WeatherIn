import Foundation

struct WeatherFiveDays: Decodable {
    let city: Name
    var list: [List?]
}

struct Name: Decodable {
    let name: String?
}

struct List: Decodable {
    let dt: Int?
    let main: Temp
    let weather: [WeatherMain]
}

struct Temp: Decodable {
    let temp: Double?
}

struct WeatherMain: Decodable {
    let main:String?
    let icon: String?
}
