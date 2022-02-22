import UIKit

class MainController: UITabBarController {
    let firstVC = FirstVC()
    let secondVC = SecondVC()
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
        firstVC.updateVCLoadingData(data: dataCurrent!, imageWeatherNow: imageWeatherNow)
    }
    
    func initialization() {
        firstVC.title = "Today"
        secondVC.title = "Forecast"
        let sunBlack = UIImage(systemName: "sun.max")
        sunBlack?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let sunBlue = UIImage(systemName: "sun.max")
        sunBlue?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        let cloudBlack = UIImage(systemName: "cloud.moon")
        cloudBlack?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let cloudBlue = UIImage(systemName: "cloud.moon")
        cloudBlue?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        firstVC.tabBarItem.image = sunBlack
        firstVC.tabBarItem.selectedImage = sunBlue
        secondVC.tabBarItem.image = cloudBlack
        secondVC.tabBarItem.selectedImage = cloudBlue
        let selectedColor = UIColor(named: "MyBlue")
        let unselectedColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.gray.cgColor
        self.tabBar.backgroundColor = .white
        self.viewControllers = [firstVC,secondVC]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.preparationFiveDaysDataForTable()
        guard let dataFiveDays = dataFiveDays else { return }
        secondVC.update(dataFiveDays: dataFiveDays, arrayImages: arrayImages)
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

