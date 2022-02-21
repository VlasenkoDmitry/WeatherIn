import Foundation
import UIKit

class ScreenSaver {
    private var viewImage = UIImageView()
    private var view = UIView()
    
    init() {
        
    }
    
    func add(view: UIView) {
        viewImage.image = UIImage(named: "ScreenSaver")
        viewImage.frame = view.frame
        view.addSubview(viewImage)
    }
    
    func remove() {
        viewImage.removeFromSuperview()
    }
}
