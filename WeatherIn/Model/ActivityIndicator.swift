import Foundation
import UIKit

 enum FormatIndicator {
    case black
    case yellow
}

class ActivityIndicator {   
    private var view: UIView?
    private var indicator = UIActivityIndicatorView(style: .large)
    
    init() {
    }
    
    func addIndicator (view: UIView, format: FormatIndicator) {
        self.view = view
        switch format {
        case .black:
            blackFormat()
        default:
            blackFormat()
        }
        view.addSubview(indicator)
    }
    
    private func blackFormat() {
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        guard let view = view else { return }
        indicator.center = view.center
        indicator.color = .black
    }
    
    func start() {
        indicator.startAnimating()
    }
    
    func remove() {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
}
