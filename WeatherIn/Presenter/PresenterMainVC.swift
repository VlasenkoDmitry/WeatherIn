import Foundation
import UIKit

class PresenterMainVC {
    private var weatherToday: WeatherToday?
    private var weatherForecast: WeatherForecastFiveDays?
    private var imageWeatherToday: UIImage?
    private var imagesWeatherForecast: [UIImage?]?
    weak private var viewOutputDelegate: ViewOutputDelegateMainVC?
    
    init(weatherToday: WeatherToday?, weatherForecast: WeatherForecastFiveDays?, imageWeatherToday: UIImage?, imageWeatherForecast: [UIImage?]? ) {
        self.weatherToday = weatherToday
        self.weatherForecast = weatherForecast
        self.imageWeatherToday = imageWeatherToday
        self.imagesWeatherForecast = imageWeatherForecast
    }
    
    func setViewOutputDelegate(viewOutputDelegate: ViewOutputDelegateMainVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
}

extension PresenterMainVC: ViewInputDelegateMainVC {
    func setDownloadedDataToPresentersViewControllers(firstVC: TodayVC, secondVC: ForecastVC) {
        firstVC.presenter.weatherToday = weatherToday
        firstVC.presenter.imageWeatherToday = imageWeatherToday
        secondVC.presenter.weatherForecast = weatherForecast
        secondVC.presenter.imagesWeatherForecast = imagesWeatherForecast
        viewOutputDelegate?.loadViewControllersToTabBar()
    }
}
