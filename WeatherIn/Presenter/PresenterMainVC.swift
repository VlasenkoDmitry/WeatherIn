import Foundation
import UIKit

class PresenterMainVC {
    private var weatherToday: WeatherToday?
    private var weatherForecast: WeatherForecastFiveDays?
    private var imageWeatherToday: UIImage?
    private var imagesWeatherForecast: [UIImage?]?
    weak private var viewOutputDelegate: ViewOutputDelegateMainVC?
    
    init(dataCurrent: WeatherToday?, dataFiveDays: WeatherForecastFiveDays?, imageWeatherNow: UIImage?, arrayImages: [UIImage?]? ) {
        self.weatherToday = dataCurrent
        self.weatherForecast = dataFiveDays
        self.imageWeatherToday = imageWeatherNow
        self.imagesWeatherForecast = arrayImages
    }
    
    func setViewInputDelegate(viewInputDelegate: ViewOutputDelegateMainVC?) {
        self.viewOutputDelegate = viewInputDelegate
    }
}

//addind all weather's data to presenters Today and Forecast controllers. We can use init() in TodayVC and ForecastVC, but to practise work with presenters i used presenter.
extension PresenterMainVC: ViewInputDelegateMainVC {
    func takeDataPresentersViewControllers(firstVC: TodayVC, secondVC: ForecastVC) {
        firstVC.presenter.weatherToday = weatherToday
        firstVC.presenter.imageWeatherToday = imageWeatherToday
        secondVC.presenter.weatherForecast = weatherForecast
        secondVC.presenter.imagesWeatherForecast = imagesWeatherForecast
        viewOutputDelegate?.loadViewControllersToTabBar()
    }
}
