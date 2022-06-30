import Foundation
import UIKit

protocol ViewOutputDelegateTodayVC: AnyObject {
    func publishDataTodayVC(weatherToday: WeatherToday?, imageWeatherToday: UIImage?)
}
