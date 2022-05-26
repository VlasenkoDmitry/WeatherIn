import Foundation

struct WeatherCurrent: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String?
    let sys: Sys
    let rain: [String : Double]?
    let snow: [String : Double]?
}

struct Coord: Codable {
    let lon: Double?
    let lat: Double?
}

struct Weather: Codable {
    let main: String?
    let icon: String?
}

struct Main: Codable {
    let temp: Double?
    let pressure: Double?
    let humidity: Double?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Double?
}

struct Sys: Codable {
    let country: String?
}
