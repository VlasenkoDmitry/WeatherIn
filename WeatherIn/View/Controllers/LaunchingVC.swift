import Foundation
import UIKit
import CoreLocation

class LaunchingVC: UIViewController {
    private let screenSaver = ScreenSaver()
    private let presenter = PresenterLaunchingVC()
    private let activityIndicator = ActivityIndicator()
    private weak var viewInputputDelegate: ViewInputDelegateLaunchingVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkPresenter()
        screenSaver.addTo(view: view)
        activityIndicator.addTo(view: view, format: .black)
    }
    
    private func linkPresenter() {
        presenter.setViewOutputDelegate(viewOutputDelegate: self)
        self.viewInputputDelegate = presenter
    }
    
    private func formatNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.start()
        presenter.beginLocationDetermination()
    }
}

//after finding coordinates and downloading all data
extension LaunchingVC: ViewOutputDelegateLaunchingVC {
    func displayMainVC(presenter: PresenterMainVC) {
        let controler = MainVC(presenter: presenter)
        self.navigationController?.pushViewController(controler, animated: true)
    }
}
