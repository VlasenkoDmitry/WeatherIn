import Foundation
import UIKit

protocol ViewOutputDelegateTodayVC: AnyObject {
    func getWeatherDataToday(weatherToday: WeatherToday?, imageWeatherToday: UIImage?)
}
