import Foundation
import UIKit

protocol ViewOutputDelegateForecastVC: AnyObject {
    func publishDataForecastVC(dataFiveDays: WeatherForecastFiveDays, arrayImages: [UIImage?]?)
}
