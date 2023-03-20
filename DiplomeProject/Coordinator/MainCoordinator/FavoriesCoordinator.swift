

import UIKit

class FavoriesCoordinator: Coordinator {
    weak var parent: Coordinator?
    var navigation: UINavigationController
    
    var childCoordinator: [Coordinator] = []
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        favorie()
    }
    
    func favorie() {
        let favorie = FavoriesController()
        favorie.coordinator = self
        navigation.pushViewController(favorie, animated: true)
    }
}
