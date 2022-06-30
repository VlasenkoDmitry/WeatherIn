import Foundation
import UIKit
import CoreLocation

//launching screen, begin location determination and load data in presenter
class LaunchingVC: UIViewController {
    private let screenSaver = ScreenSaver()
    private var presenter = PresenterLaunchingVC()
    private weak var viewInputputDelegate: ViewInputDelegateLaunchingVC?
    private var actInd = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewOutputDelegate(viewOutputDelegate: self)
        self.viewInputputDelegate = presenter
        initialization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.beginLocationDetermination()
    }
    
    private func initialization() {
        screenSaver.add(view: view)
        actInd.addIndicator(view: view, format: .black)
        actInd.start()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

//after finding coordinates and downloading all data - open main controller(tab controller which consists of two vc: tooday and forecast)
extension LaunchingVC: ViewOutputDelegateLaunchingVC {
    func initializeTabBarController(presenter: PresenterMainVC) {
        let controler = MainVC(presenter: presenter)
        self.navigationController?.pushViewController(controler, animated: true)
    }
}
