import UIKit

class MainVC: UITabBarController {
    private let todayVC = TodayVC()
    private let forecastVC = ForecastVC()
    private let presenter : PresenterMainVC
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
        linkPresenter()
        presenter.setDownloadedDataToPresentersViewControllers(firstVC: todayVC, secondVC: forecastVC)
    }
    
    private func linkPresenter() {
        presenter.setViewOutputDelegate(viewOutputDelegate: self)
        self.viewInputDelegate = presenter
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeTabBar()
    }
    
    func initializeTabBar() {
        fillTabBar()
        formatTabbar()
    }
    
    private func fillTabBar() {
        todayVC.title = "Today".localize()
        forecastVC.title = "Forecast".localize()
        todayVC.tabBarItem.image = UIImage(systemName: "sun.max")
        todayVC.tabBarItem.selectedImage = UIImage(systemName: "sun.max")
        forecastVC.tabBarItem.image = UIImage(systemName: "cloud.moon")
        forecastVC.tabBarItem.selectedImage = UIImage(systemName: "cloud.moon")
    }
    
    private func formatTabbar() {
        todayVC.tabBarItem.image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        todayVC.tabBarItem.selectedImage?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        forecastVC.tabBarItem.image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        forecastVC.tabBarItem.selectedImage?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        let selectedColor = UIColor(named: "MyBlue")
        let unselectedColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor ?? UIColor.blue ], for: .selected)
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.gray.cgColor
        self.tabBar.backgroundColor = .white
    }
}

// Adding view controllers to tab bar after adding all weathers data to presenters Today and Forecast controllers
extension MainVC: ViewOutputDelegateMainVC {
    func loadViewControllersToTabBar() {
        self.viewControllers = [todayVC, forecastVC]
    }
}

