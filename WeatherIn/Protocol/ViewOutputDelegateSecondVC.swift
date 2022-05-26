import Foundation
import UIKit

protocol ViewOutputDelegateSecondVC: AnyObject {
    func publishDataSecondVC(dataFiveDays: WeatherFiveDays, arrayImages: [UIImage?]?)
}
