
import UIKit

class HomeCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    let navigation: UINavigationController?
    weak var parent: Coordinator?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        homePage()
    }
    
    func homePage() {
        let homeVc = HomeController()
        homeVc.coordinator = self
        navigation?.pushViewController(homeVc, animated: true)
    }
    
    func showGalleryFollower() {
        
    }
    
    func showMoreInfoToNewPage() {
        
    }
}
