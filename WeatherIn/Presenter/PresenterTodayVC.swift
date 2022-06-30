import Foundation
import UIKit

class PresenterTodayVC {
    var dataCurrent: WeatherToday?
    var imageWeatherNow: UIImage?
    weak private var viewOutputDelegate: ViewOutputDelegateTodayVC?
    
    func setViewOutputDelegate(viewOutputDelegate: ViewOutputDelegateTodayVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
}

extension PresenterTodayVC: ViewInputDelegateFirstVC {
    func takeDataFirstVC() {
        viewOutputDelegate?.publishDataTodayVC(dataCurrent: dataCurrent, imageWeatherNow: imageWeatherNow)
    }
}
