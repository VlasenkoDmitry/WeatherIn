
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
    
}
