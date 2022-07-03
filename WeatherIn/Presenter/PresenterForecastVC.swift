import Foundation
import UIKit

class PresenterForecastVC {
    var weatherForecast: WeatherForecastFiveDays?
    var imagesWeatherForecast: [UIImage?]?
    
    weak private var viewOutputDelegate: ViewOutputDelegateForecastVC?
    
    func setViewOutputDelegate(viewOutputDelegate: ViewOutputDelegateForecastVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
    
    private func prepareWeatherToDisplay() {
        addNamesDaysInWeather()
    }
    
    private func addNamesDaysInWeather() {
        guard let firstDate = weatherForecast?.list[0]?.dt else { return }
        var numberDay = Int(Double(firstDate) / Double(86400))
        guard let listForecast = weatherForecast?.list else { return }
        var numberForecasts = listForecast.count
        for i in 0...numberForecasts {
            if i == 0 {
                weatherForecast?.list.insert(nil, at: 0)
                imagesWeatherForecast?.insert(nil, at: 0)
                numberForecasts += 1
                continue
            }
            if let dateUTC = weatherForecast?.list[i]?.dt {
                let numberDayNewCurrent = Int(Double(dateUTC) / Double(86400))
                if numberDay == numberDayNewCurrent { continue } else {
                    weatherForecast?.list.insert(nil, at: i - 1)
                    imagesWeatherForecast?.insert(nil, at: i - 1)
                    numberDay = numberDayNewCurrent
                    numberForecasts += 1
                }
            }
        }
    }
}

// preparing data for display
extension PresenterForecastVC: ViewInputDelegateForecastVC {
    func transmitWeatherDataForecastToForecastVC() {
        prepareWeatherToDisplay()
        guard let dataFiveDays = weatherForecast else { return }
        viewOutputDelegate?.publishDataForecastVC(weatherForecast: dataFiveDays, arrayImages: imagesWeatherForecast)
    }
}
