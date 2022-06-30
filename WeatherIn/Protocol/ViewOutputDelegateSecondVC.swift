import Foundation
import UIKit

protocol ViewOutputDelegateSecondVC: AnyObject {
    func publishDataSecondVC(dataFiveDays: WeatherForecastFiveDays, arrayImages: [UIImage?]?)
}
