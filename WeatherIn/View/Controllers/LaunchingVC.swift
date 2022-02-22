import Foundation
import UIKit
import CoreLocation

class LaunchingVC: UIViewController {
    let screenSaver = ScreenSaver()
    var presenter = PresenterLVC()
    private weak var viewOutputDelegate: ViewOutputDelegateMC?
    var lat = 0
    var lon = 0
    var nameCity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewInputDelegate(viewInputDelegate: self)
        self.viewOutputDelegate = presenter
        initialization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.beginLocationDetermination()
    }

    func initialization() {
        screenSaver.add(view: view)
        ActivityIndicator.shared.addIndicator(view: view, format: .black)
        ActivityIndicator.shared.start()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension LaunchingVC: ViewInputDelegateMC {
    func initializeTabBarController(presenter: PresenterMC) {
        self.screenSaver.remove()
        ActivityIndicator.shared.remove()
        guard let controler = self.storyboard?.instantiateViewController(identifier: "MainController") as? MainController else { return }
        controler.presenter = presenter
        self.navigationController?.pushViewController(controler, animated: true)
    }
}
