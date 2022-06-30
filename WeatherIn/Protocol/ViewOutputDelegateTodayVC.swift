import Foundation
import UIKit

protocol ViewOutputDelegateTodayVC: AnyObject {
    func publishDataTodayVC(dataCurrent: WeatherToday?, imageWeatherNow: UIImage?)
}
