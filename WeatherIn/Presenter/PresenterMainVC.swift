import Foundation
import UIKit

class PresenterMainVC {
    private var weatherToday: WeatherToday?
    private var weatherForecast: WeatherForecastFiveDays?
    private var imageWeatherNow: UIImage?
    private var arrayImages: [UIImage?]?
    weak private var viewOutputDelegate: ViewOutputDelegateMainVC?
    
    init(dataCurrent: WeatherToday?, dataFiveDays: WeatherForecastFiveDays?, imageWeatherNow: UIImage?, arrayImages: [UIImage?]? ) {
        self.weatherToday = dataCurrent
        self.weatherForecast = dataFiveDays
        self.imageWeatherNow = imageWeatherNow
        self.arrayImages = arrayImages
    }
    
    func setViewInputDelegate(viewInputDelegate: ViewOutputDelegateMainVC?) {
        self.viewOutputDelegate = viewInputDelegate
    }
}

//addind all weather's data to presenters Today and Forecast controllers. We can use init() in TodayVC and ForecastVC, but to practise work with presenters i used presenter.
extension PresenterMainVC: ViewInputDelegateMainVC {
    func takeDataPresentersViewControllers(firstVC: TodayVC, secondVC: ForecastVC) {
        firstVC.presenter.dataCurrent = weatherToday
        firstVC.presenter.imageWeatherNow = imageWeatherNow
        secondVC.presenter.dataFiveDays = weatherForecast
        secondVC.presenter.arrayImages = arrayImages
        viewOutputDelegate?.loadViewControllersToTabBar()
    }
}
