import Foundation
import UIKit

extension UILabel {
    func format(size: CGFloat = 17, weight: UIFont.Weight = .light, textColor: UIColor = .black, textAlignment: NSTextAlignment = .center) {
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: size ,weight: weight)
    }
}
