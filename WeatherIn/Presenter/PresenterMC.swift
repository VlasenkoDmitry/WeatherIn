import Foundation
import UIKit

class PresenterMC {
    var dataCurrent: WeatherCurrent?
    var dataFiveDays: WeatherFiveDays?
    var imageWeatherNow: UIImage?
    var arrayImages: [UIImage?]?
    weak private var viewInputDelegate: ViewInputDelegateLVC?
    
    init(dataCurrent: WeatherCurrent?, dataFiveDays: WeatherFiveDays?, imageWeatherNow: UIImage?, arrayImages: [UIImage?]? ) {
        self.dataCurrent = dataCurrent
        self.dataFiveDays = dataFiveDays
        self.imageWeatherNow = imageWeatherNow
        self.arrayImages = arrayImages
    }
    
    func setViewInputDelegate(viewInputDelegate:ViewInputDelegateLVC?) {
        self.viewInputDelegate = viewInputDelegate
    }
    

}

extension PresenterMC: ViewOutputDelegateLVC {
    func getDataFirstVC() {

    }
   
    func preparationFiveDaysDataForTable() {

    }
}
