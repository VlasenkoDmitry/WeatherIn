
import Foundation
import UIKit
import SnapKit

extension UIView {
    
    //оформление StatusBar
    func layoutStatusBar(bar: UIView) {
        self.addSubview(bar)
        bar.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.left.right.top.equalToSuperview().inset(0)
        }
    }
    //оформление NavigationBar
    func layoutNavigationBar(navigationBar: UIView, statusBar: UIView) {
        self.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.top.equalTo(statusBar.snp.bottom)
            maker.left.right.equalToSuperview().inset(0)
        }
        var nameVC = UILabel()
        navigationBar.addSubview(nameVC)
        nameVC.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(navigationBar)
        }
    }
    
    /** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
    
    //рисует одноцветную пунктирную границу по указанным сторонам, с отступом по отношению к стороне(distanceBorder) и обрезкой линии(trimLine)
    func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5,distanceBorder: CGFloat = 0, corners: UIRectSide,trimLine: CGFloat = 0) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
                 // Интервал между длиной каждого сегмента и ростками между каждым абзацем
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]

        let path = CGMutablePath()
        if corners.contains(.left) {
            path.move(to: CGPoint(x: 0 - distanceBorder, y: self.layer.bounds.height - trimLine + distanceBorder))
            path.addLine(to: CGPoint(x: 0 - distanceBorder, y: trimLine - distanceBorder))
        }
        if corners.contains(.top){
            path.move(to: CGPoint(x: trimLine - distanceBorder, y: 0 - distanceBorder))
            path.addLine(to: CGPoint(x: self.layer.bounds.width - trimLine + distanceBorder, y: 0 - distanceBorder))
        }
        if corners.contains(.right){
            path.move(to: CGPoint(x: self.layer.bounds.width + distanceBorder, y: 0 - distanceBorder + trimLine))
            path.addLine(to: CGPoint(x: self.layer.bounds.width + distanceBorder, y: self.layer.bounds.height + distanceBorder - trimLine))
        }
        if corners.contains(.bottom){
            path.move(to: CGPoint(x: self.layer.bounds.width + distanceBorder - trimLine, y: self.layer.bounds.height + distanceBorder))
            path.addLine(to: CGPoint(x: 0 - distanceBorder + trimLine, y: self.layer.bounds.height + distanceBorder))
        }
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
 //рисует разноцветную пунктирную границу по указанным сторонам, без отступа
    func drawLineDifferentColor(colorArray:[UIColor],lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5, corners: UIRectSide) {
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
            if corners.contains(.top){
                let lengthLine =  self.layer.bounds.width / CGFloat(colorArray.count)
     
                path.move(to: CGPoint(x: CGFloat(index) * lengthLine, y: 0))
     
                path.addLine(to: CGPoint(x: CGFloat(( index + 1 )) * lengthLine, y: 0))
            }
            if corners.contains(.right){
                let lengthLine =  self.layer.bounds.height / CGFloat(colorArray.count)
     
                path.move(to: CGPoint(x: self.layer.bounds.width, y: CGFloat(index) * lengthLine))
     
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: CGFloat(( index + 1 )) * lengthLine))
            }
            if corners.contains(.bottom){
                let lengthLine =  self.layer.bounds.width / CGFloat(colorArray.count)
     
                path.move(to: CGPoint(x: CGFloat(index) * lengthLine, y: self.layer.bounds.height))

                path.addLine(to: CGPoint(x: CGFloat(( index + 1 )) * lengthLine, y:  self.layer.bounds.height))
            }
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
            
        }
    }
}
