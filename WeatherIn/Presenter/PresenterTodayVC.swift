import Foundation
import UIKit

class PresenterTodayVC {
    private var weatherToday: WeatherToday?
    private var imageWeatherToday: UIImage?
    weak private var viewOutputDelegate: ViewOutputDelegateTodayVC?
    
    func setViewOutputDelegate(viewOutputDelegate: ViewOutputDelegateTodayVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
    
    func updateWeather(weatherToday: WeatherToday?, imageWeatherToday: UIImage?) {
        self.weatherToday = weatherToday
        self.imageWeatherToday = imageWeatherToday
    }
}

extension PresenterTodayVC: ViewInputDelegateFirstVC {
    func transmitWeatherDataTodayToTodayVC() {
        viewOutputDelegate?.getWeatherDataToday(weatherToday: weatherToday, imageWeatherToday: imageWeatherToday)
    }
}
