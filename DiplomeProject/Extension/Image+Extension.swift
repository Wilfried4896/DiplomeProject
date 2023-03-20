
import UIKit

extension UIImageView {
    
    func imageProfile() {
        isUserInteractionEnabled = true
        layer.masksToBounds = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        image = UIImage(systemName: "person.circle")
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func imagePost() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func likesVuesImages(_ sfSymbole: String) {
        image = UIImage(systemName: sfSymbole)
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = UIColor(named: "TextColor")
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 20),
            self.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
}
