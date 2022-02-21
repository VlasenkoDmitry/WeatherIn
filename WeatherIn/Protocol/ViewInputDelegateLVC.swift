import Foundation
import UIKit

protocol ViewInputDelegateLVC: AnyObject {
    func setupDataFirstVC(dataCurrent: WeatherCurrent,imageWeatherNow: UIImage?)
    func setupDataSecondVC(dataFiveDays: WeatherFiveDays, arrayImages: [UIImage?]?)
}
