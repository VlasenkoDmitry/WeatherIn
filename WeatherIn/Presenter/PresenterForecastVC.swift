import Foundation
import UIKit

class PresenterForecastVC {
    var dataFiveDays: WeatherForecastFiveDays?
    var arrayImages: [UIImage?]?
    
    weak private var viewOutputDelegate: ViewOutputDelegateForecastVC?
    
    func setViewOutputDelegate(viewOutputDelegate: ViewOutputDelegateForecastVC?) {
        self.viewOutputDelegate = viewOutputDelegate
    }
    
    // add extra data to devide by days of week
    private func addNamesDays() {
        guard let firstDate = dataFiveDays?.list[0]?.dt else { return }
        var countDay = Int(Double(firstDate) / Double(86400))
        guard let data = dataFiveDays?.list else { return }
        var counterData = data.count
        for i in 0...counterData {
            if i == 0 {
                dataFiveDays?.list.insert(nil, at: 0)
                arrayImages?.insert(nil, at: 0)
                counterData += 1
                continue
            }
            if let dateUTC = dataFiveDays?.list[i]?.dt {
                let countDayNewCurrent = Int(Double(dateUTC) / Double(86400))
                if countDay == countDayNewCurrent { continue } else {
                    dataFiveDays?.list.insert(nil, at: i - 1)
                    arrayImages?.insert(nil, at: i - 1)
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
        guard let dataFiveDays = dataFiveDays else { return }
        viewOutputDelegate?.publishDataForecastVC(dataFiveDays: dataFiveDays, arrayImages: arrayImages)
    }
}
