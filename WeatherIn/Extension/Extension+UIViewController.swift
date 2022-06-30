import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style : .default, handler : nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
