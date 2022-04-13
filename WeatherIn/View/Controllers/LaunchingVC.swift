import Foundation
import UIKit
import CoreLocation

class LaunchingVC: UIViewController {
    private let screenSaver = ScreenSaver()
    private var presenter = PresenterLVC()
    private weak var viewOutputDelegate: ViewOutputDelegateMC?
    private var lat = 0
    private var lon = 0
    private var nameCity = ""
    private var actInd = ActivityIndicator()
    
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
        actInd.addIndicator(view: view, format: .black)
        actInd.start()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension LaunchingVC: ViewInputDelegateMC {
    func showAlertError(title: String, text: String) {
        showAlert(title: title, text: text)
    }
    
    func initializeTabBarController(presenter: PresenterMC) {
        self.screenSaver.remove()
        actInd.remove()
        guard let controler = self.storyboard?.instantiateViewController(identifier: "MainController") as? MainController else { return }
        controler.presenter = presenter
        self.navigationController?.pushViewController(controler, animated: true)
    }
}
