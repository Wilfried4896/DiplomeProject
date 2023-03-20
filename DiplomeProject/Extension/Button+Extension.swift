
import UIKit

extension UIButton {
    
    func createPostIcon(_ sfSymbole: String) {
        setImage(UIImage(systemName: sfSymbole), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = UIColor(named: "TextColor")
        
//        NSLayoutConstraint.activate([
//            self.widthAnchor.constraint(equalToConstant: 48),
//            self.heightAnchor.constraint(equalToConstant: 48)
//        ])
    }
    
    func postRecorder(_ _setTitle: String) {
        tintColor = UIColor(named: "TextColor")
        setTitle(_setTitle, for: .normal)
        titleLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func profileButton(_setTitle: String, sfSymbole: String) {
        setTitle(_setTitle, for: .normal)
        setImage(UIImage(systemName: sfSymbole), for: .normal)
        tintColor = UIColor(named: "TextColor")
        translatesAutoresizingMaskIntoConstraints = false
    }
}
