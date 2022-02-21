import UIKit

class MainController: UITabBarController {

    var presenter: PresenterMC?
    var dataCurrent: WeatherCurrent?
    var dataFiveDays: WeatherFiveDays?
    var imageWeatherNow: UIImage?
    var arrayImages: [UIImage?]?
    private weak var viewOutputDelegate: ViewOutputDelegateLVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setViewInputDelegate(viewInputDelegate: self)
        self.viewOutputDelegate = presenter
        initialization()
        presenter?.getDataFirstVC()

    }
    
    func initialization() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.preparationFiveDaysDataForTable()
        
    }
}

extension MainController: ViewInputDelegateLVC {
    func setupDataSecondVC(dataFiveDays: WeatherFiveDays, arrayImages: [UIImage?]?) {
        self.dataFiveDays = dataFiveDays
        self.arrayImages = arrayImages
    }
    
    func setupDataFirstVC(dataCurrent: WeatherCurrent, imageWeatherNow: UIImage?) {
        self.dataCurrent = dataCurrent
        self.imageWeatherNow = imageWeatherNow
    }
    

}

