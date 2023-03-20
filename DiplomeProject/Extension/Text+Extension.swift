
import Foundation
import UIKit


extension UILabel {
  
    func textHeader(_ ofSize: CGFloat, _ weight: UIFont.Weight) {
        font = UIFont.systemFont(ofSize: ofSize, weight: weight)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

