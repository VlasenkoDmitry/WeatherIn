import Foundation
import UIKit

class PresenterMC {
    private var dataCurrent: WeatherCurrent?
    private var dataFiveDays: WeatherFiveDays?
    private var imageWeatherNow: UIImage?
    private var arrayImages: [UIImage?]?
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
    
    private func preparation() {
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

extension PresenterMC: ViewOutputDelegateLVC {
    func getDataFirstVC() {
        guard let dataCurrent = dataCurrent else { return }
        viewInputDelegate?.setupDataFirstVC(dataCurrent: dataCurrent, imageWeatherNow: imageWeatherNow)
    }
    
    func preparationFiveDaysDataForTable() {
        preparation()
        guard let dataFiveDays = dataFiveDays else { return }
        self.viewInputDelegate?.setupDataSecondVC(dataFiveDays: dataFiveDays, arrayImages: arrayImages)
    }
}
