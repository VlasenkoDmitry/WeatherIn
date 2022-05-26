import Foundation
import UIKit

protocol imageAndTextSettingsInDetailsView {
    func reset(view: UIView)
    func addImageView()
    func addTextLabel()
    func formatImageView()
    func formatLabel()
    func returnView() -> UIView
}


