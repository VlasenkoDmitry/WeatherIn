import Foundation
import UIKit

class PresenterMainVC {
    private var dataCurrent: WeatherToday?
    private var dataFiveDays: WeatherForecastFiveDays?
    private var imageWeatherNow: UIImage?
    private var arrayImages: [UIImage?]?
    weak private var viewOutputDelegate: ViewOutputDelegateMainVC?
    
    init(dataCurrent: WeatherToday?, dataFiveDays: WeatherForecastFiveDays?, imageWeatherNow: UIImage?, arrayImages: [UIImage?]? ) {
        self.dataCurrent = dataCurrent
        self.dataFiveDays = dataFiveDays
        self.imageWeatherNow = imageWeatherNow
        self.arrayImages = arrayImages
    }
    
    func setViewInputDelegate(viewInputDelegate: ViewOutputDelegateMainVC?) {
        self.viewOutputDelegate = viewInputDelegate
    }
}

//addind all weather's data to presenters First and Second controllers. We can use init() in firstVC and secondVC, but to practise work with presenters i used presenter.
extension PresenterMainVC: ViewInputDelegateMainVC {
    func takeDataPresentersViewControllers(firstVC: TodayVC, secondVC: ForecastVC) {
        firstVC.presenter.dataCurrent = dataCurrent
        firstVC.presenter.imageWeatherNow = imageWeatherNow
        secondVC.presenter.dataFiveDays = dataFiveDays
        secondVC.presenter.arrayImages = arrayImages
        viewOutputDelegate?.loadViewControllersToTabBar()
    }
}
