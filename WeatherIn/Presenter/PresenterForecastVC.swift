import Foundation
import UIKit

class PresenterForecastVC {
    var weatherForecast: WeatherForecastFiveDays?
    var imagesWeatherForecast: [UIImage?]?
    
    weak private var viewOutputDelegate: ViewOutputDelegateForecastVC?
    
    func setViewOutputDelegate(viewOutputDelegate: ViewOutputDelegateForecastVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
    
    // add extra data to devide by days of week
    private func addNamesDays() {
        guard let firstDate = weatherForecast?.list[0]?.dt else { return }
        var countDay = Int(Double(firstDate) / Double(86400))
        guard let data = weatherForecast?.list else { return }
        var counterData = data.count
        for i in 0...counterData {
            if i == 0 {
                weatherForecast?.list.insert(nil, at: 0)
                imagesWeatherForecast?.insert(nil, at: 0)
                counterData += 1
                continue
            }
            if let dateUTC = weatherForecast?.list[i]?.dt {
                let countDayNewCurrent = Int(Double(dateUTC) / Double(86400))
                if countDay == countDayNewCurrent { continue } else {
                    weatherForecast?.list.insert(nil, at: i - 1)
                    imagesWeatherForecast?.insert(nil, at: i - 1)
                    countDay = countDayNewCurrent
                    counterData += 1
                }
            }
        }
    }
}

// preparing data for display
extension PresenterForecastVC: ViewInputDelegateForecastVC {
    func downloadDataForecastVC() {
        addNamesDays()
        guard let dataFiveDays = weatherForecast else { return }
        viewOutputDelegate?.publishDataForecastVC(dataFiveDays: dataFiveDays, arrayImages: imagesWeatherForecast)
    }
}
