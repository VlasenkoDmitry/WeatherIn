import Foundation
import UIKit

protocol ParameterWeather {
    func reset(view: UIView)
    func addImageView()
    func addTextLabel()
    func formatImageView()
    func formatLabel()
    func returnView() -> UIView
}


