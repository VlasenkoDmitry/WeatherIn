import Foundation
import UIKit

protocol ViewOutputDelegateForecastVC: AnyObject {
    func publishDataForecastVC(weatherForecast: WeatherForecastFiveDays, arrayImages: [UIImage?]?)
}
