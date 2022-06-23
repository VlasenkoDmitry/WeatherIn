import UIKit

class MainController: UITabBarController {
    private let firstVC = FirstVC()
    private let secondVC = SecondVC()
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
        firstVC.title = "Today".localize()
        secondVC.title = "Forecast".localize()
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.takeDataPresentersViewControllers(firstVC: firstVC, secondVC: secondVC)
    }
}

// extension to delegate from presenterMainVC. Adding view controllers to tab bar after adding all weathers data to presenters First and Second controllers
extension MainController: ViewOutputDelegateMainVC {
    func loadViewControllersToTabBar() {
        self.viewControllers = [firstVC, secondVC]
    }
}

