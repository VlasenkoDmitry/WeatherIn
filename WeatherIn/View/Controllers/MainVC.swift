import UIKit

class MainVC: UITabBarController {
    private let todayVC = TodayVC()
    private let forecastVC = ForecastVC()
    private var presenter : PresenterMainVC
    private weak var viewInputDelegate: ViewInputDelegateMainVC?
    
    init(presenter: PresenterMainVC) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewInputDelegate(viewInputDelegate: self)
        self.viewInputDelegate = presenter
        initialization()
    }
    
    private func initialization() {
        todayVC.title = "Today".localize()
        forecastVC.title = "Forecast".localize()
        let sunBlack = UIImage(systemName: "sun.max")
        sunBlack?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let sunBlue = UIImage(systemName: "sun.max")
        sunBlue?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        let cloudBlack = UIImage(systemName: "cloud.moon")
        cloudBlack?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let cloudBlue = UIImage(systemName: "cloud.moon")
        cloudBlue?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        todayVC.tabBarItem.image = sunBlack
        todayVC.tabBarItem.selectedImage = sunBlue
        forecastVC.tabBarItem.image = cloudBlack
        forecastVC.tabBarItem.selectedImage = cloudBlue
        let selectedColor = UIColor(named: "MyBlue")
        let unselectedColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor ?? UIColor.blue ], for: .selected)
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.gray.cgColor
        self.tabBar.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.takeDataPresentersViewControllers(firstVC: todayVC, secondVC: forecastVC)
    }
}

// extension to delegate from presenterMainVC. Adding view controllers to tab bar after adding all weathers data to presenters Today and Forecast controllers
extension MainVC: ViewOutputDelegateMainVC {
    func loadViewControllersToTabBar() {
        self.viewControllers = [todayVC, forecastVC]
    }
}

