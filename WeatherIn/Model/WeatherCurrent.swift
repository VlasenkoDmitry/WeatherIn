import Foundation

struct WeatherCurrent: Decodable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String?
    let sys: Sys
    let rain: [String : Double]?
    let snow: [String : Double]?
}

struct Coord: Decodable {
    let lon: Double?
    let lat: Double?
}

struct Weather: Decodable {
    let main: String?
    let icon: String?
}

struct Main: Decodable {
    let temp: Double?
    let pressure: Double?
    let humidity: Double?
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Double?
}

struct Sys: Decodable {
    let country: String?
}
