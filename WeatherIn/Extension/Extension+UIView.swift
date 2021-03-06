
import Foundation
import UIKit
import SnapKit

extension UIView {
    
    func setLayoutStatusBarView(bar: UIView) {
        self.addSubview(bar)
        bar.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.left.right.top.equalToSuperview().inset(0)
        }
    }
    
    func setLayoutNavigationBar(navigationBar: UIView, topElement: UIView) {
        self.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.top.equalTo(topElement.snp.bottom)
            maker.left.right.equalToSuperview().inset(0)
        }
        let nameVC = UILabel()
        navigationBar.addSubview(nameVC)
        nameVC.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(navigationBar)
        }
    }
    
    /** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func getAllSubViewsOf<T : UIView>(type : T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T {
                all.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
    
    /// one-color dotted line on the specified sides, indentation, border cropping
    func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5, distanceBorder: CGFloat = 0, corners: UIRectSide,trimLine: CGFloat = 0) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        /// The interval between the length of each segment and the sprouts between each paragraph
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        if corners.contains(.left) {
            path.move(to: CGPoint(x: 0 - distanceBorder, y: self.layer.bounds.height - trimLine + distanceBorder))
            path.addLine(to: CGPoint(x: 0 - distanceBorder, y: trimLine - distanceBorder))
        }
        if corners.contains(.top) {
            path.move(to: CGPoint(x: trimLine - distanceBorder, y: 0 - distanceBorder))
            path.addLine(to: CGPoint(x: self.layer.bounds.width - trimLine + distanceBorder, y: 0 - distanceBorder))
        }
        if corners.contains(.right) {
            path.move(to: CGPoint(x: self.layer.bounds.width + distanceBorder, y: 0 - distanceBorder + trimLine))
            path.addLine(to: CGPoint(x: self.layer.bounds.width + distanceBorder, y: self.layer.bounds.height + distanceBorder - trimLine))
        }
        if corners.contains(.bottom) {
            path.move(to: CGPoint(x: self.layer.bounds.width + distanceBorder - trimLine, y: self.layer.bounds.height + distanceBorder))
            path.addLine(to: CGPoint(x: 0 - distanceBorder + trimLine, y: self.layer.bounds.height + distanceBorder))
        }
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    /// multi-colored dotted border on the specified sides, without cropping
    func drawLineDifferentColor(colorArray:[UIColor], lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5, corners: UIRectSide) {
        for (index,color) in colorArray.enumerated() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = self.bounds
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
            
            let path = CGMutablePath()
            if corners.contains(.left) {
                let lengthLine =  self.layer.bounds.height / CGFloat(colorArray.count)
                path.move(to: CGPoint(x: 0, y: CGFloat(index) * lengthLine))
                path.addLine(to: CGPoint(x: 0, y: CGFloat(( index + 1 )) * lengthLine))
            }
            if corners.contains(.top) {
                let lengthLine =  self.layer.bounds.width / CGFloat(colorArray.count)
                path.move(to: CGPoint(x: CGFloat(index) * lengthLine, y: 0))
                path.addLine(to: CGPoint(x: CGFloat(( index + 1 )) * lengthLine, y: 0))
            }
            if corners.contains(.right) {
                let lengthLine =  self.layer.bounds.height / CGFloat(colorArray.count)
                path.move(to: CGPoint(x: self.layer.bounds.width, y: CGFloat(index) * lengthLine))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: CGFloat(( index + 1 )) * lengthLine))
            }
            if corners.contains(.bottom) {
                let lengthLine =  self.layer.bounds.width / CGFloat(colorArray.count)
                path.move(to: CGPoint(x: CGFloat(index) * lengthLine, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: CGFloat(( index + 1 )) * lengthLine, y:  self.layer.bounds.height))
            }
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    func setTextToLabel(text: String?, measure: String?) {
        let label = self.getAllSubViewsOf(type: UILabel.self)[0]
        label.text = "\(text ?? "") " + "\(measure ?? "")"
    }
}
