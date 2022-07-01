import Foundation
import UIKit

protocol ViewOutputDelegateTodayVC: AnyObject {
    func getrWeatherDataToday(weatherToday: WeatherToday?, imageWeatherToday: UIImage?)
}
