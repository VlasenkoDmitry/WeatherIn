import Foundation

protocol ViewInputDelegateMC: AnyObject {
    func initializeTabBarController(presenter: PresenterMC)
    func showAlertError(title: String, text: String)
}
