import Foundation
import UIKit
import SnapKit

/// For the practice of the Builder we create viewParameters not by creating a separate inheritor UIView class.
class BuilderViewParameterWeather: ParameterWeather {
    private var view = UIView()
    
    func reset(view: UIView) {
        self.view = view
    }
    
    func addImageView() {
        let imageView = UIImageView()
        view.addSubview(imageView)
    }
    
    func addTextLabel() {
        let label = UILabel()
        view.addSubview(label)
    }
    
    func formatImageView() {
        let imageView = view.getAllSubViewsOf(type: UIImageView.self)[0]
        imageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(20)
            maker.center.equalTo(view)
        }
    }
    
    func formatLabel() {
        let label = view.getAllSubViewsOf(type: UILabel.self)[0]
        let imageView = view.getAllSubViewsOf(type: UIImageView.self)[0]
        label.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(view)
            maker.top.equalTo(imageView.snp.bottom)
        }
        label.textAlignment = .center
    }
    
    func returnView() -> UIView {
        return view
    }
}
