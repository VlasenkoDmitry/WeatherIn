import Foundation
import UIKit

class DirectorViewParameterWeather {
    private var builder: ParameterWeather
    
    init(builder: ParameterWeather) {
        self.builder = builder
    }
    
    func setBuilder(builder: ParameterWeather) {
        self.builder = builder
    }
    
    func changeView() -> UIView {
        builder.addImageView()
        builder.addTextLabel()
        builder.formatImageView()
        builder.formatLabel()
        return builder.returnView()
    }
}
