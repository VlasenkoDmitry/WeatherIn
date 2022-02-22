import Foundation
import UIKit

class DirectorViewsOfDetailsView {
    private var builder: imageAndTextSettingsInDetailsView
    
    init(builder: imageAndTextSettingsInDetailsView) {
        self.builder = builder
    }
    
    func setBuilder(builder: imageAndTextSettingsInDetailsView) {
        self.builder = builder
    }
    
    func changeView() -> UIView{
        builder.addImageView()
        builder.addTextLabel()
        builder.formatImageView()
        builder.formatLabel()
        return builder.returnView()
    }
}
