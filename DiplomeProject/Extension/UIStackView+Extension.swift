
import UIKit

extension UIStackView {
    func postHorizontal() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .equalSpacing
    }
    
    func postVertical(_ spacingVertical: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        spacing = spacingVertical
        axis = .vertical
    }
}
