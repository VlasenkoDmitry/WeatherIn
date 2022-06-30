import Foundation
import UIKit

class PresenterTodayVC {
    var weatherToday: WeatherToday?
    var imageWeatherToday: UIImage?
    weak private var viewOutputDelegate: ViewOutputDelegateTodayVC?
    
    func setViewOutputDelegate(viewOutputDelegate: ViewOutputDelegateTodayVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
}

extension PresenterTodayVC: ViewInputDelegateFirstVC {
    func takeDataFirstVC() {
        viewOutputDelegate?.publishDataTodayVC(dataCurrent: weatherToday, imageWeatherNow: imageWeatherToday)
    }
}
