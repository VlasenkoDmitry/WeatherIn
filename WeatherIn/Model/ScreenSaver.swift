import Foundation
import UIKit

class ScreenSaver {
    private var viewImage = UIImageView()
    
    init() {
        
    }
    
    func addTo(view: UIView) {
        viewImage.image = UIImage(named: "ScreenSaver")
        viewImage.frame = view.frame
        view.addSubview(viewImage)
    }
    
    func remove() {
        viewImage.removeFromSuperview()
    }
}
