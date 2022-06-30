import Foundation
import UIKit

class PresenterFirstVC {
    var dataCurrent: WeatherToday?
    var imageWeatherNow: UIImage?
    weak private var viewOutputDelegate: ViewOutputDelegateFirstVC?
    
    func setViewOutputDelegate(viewOutputDelegate: ViewOutputDelegateFirstVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
}

extension PresenterFirstVC: ViewInputDelegateFirstVC {
    func takeDataFirstVC() {
        viewOutputDelegate?.publishDataFirstVC(dataCurrent: dataCurrent, imageWeatherNow: imageWeatherNow)
    }
}
