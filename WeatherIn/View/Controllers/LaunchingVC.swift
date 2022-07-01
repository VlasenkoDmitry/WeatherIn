import Foundation
import UIKit
import CoreLocation

//launching screen, begin location determination and load data in presenter
class LaunchingVC: UIViewController {
    private let screenSaver = ScreenSaver()
    private var presenter = PresenterLaunchingVC()
    private weak var viewInputputDelegate: ViewInputDelegateLaunchingVC?
    private var activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkPresenter()
        screenSaver.add(view: view)
        addTurnOnIndicatior()
        formatNavigationBar()
    }
    
    private func linkPresenter() {
        presenter.setViewOutputDelegate(viewOutputDelegate: self)
        self.viewInputputDelegate = presenter
    }
    
    private func addTurnOnIndicatior() {
        activityIndicator.addIndicator(view: view, format: .black)
        activityIndicator.start()
    }
    
    private func formatNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.beginLocationDetermination()
    }
}

//after finding coordinates and downloading all data - open main controller(tab controller which consists of two vc: tooday and forecast)
extension LaunchingVC: ViewOutputDelegateLaunchingVC {
    func displayMainVC(presenter: PresenterMainVC) {
        let controler = MainVC(presenter: presenter)
        self.navigationController?.pushViewController(controler, animated: true)
    }
}
