

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    weak var parent: Coordinator?
    
    var navigation: UITabBarController
    
    init(navigation: UITabBarController) {
        self.navigation = navigation
        navigation.tabBar.tintColor = .systemOrange
    }
    
    func start() {
        
        let homeNavigation = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigation: homeNavigation)
        homeNavigation.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.circle"), tag: 0)
        homeCoordinator.parent = self
        
        
        let profileNavigation = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigation: profileNavigation)
        profileNavigation.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.2.circle"), tag: 2)
        profileCoordinator.parent = self
        
        
        let favoriesNavigation = UINavigationController()
        let favoriesCoordinator = FavoriesCoordinator(navigation: favoriesNavigation)
        favoriesNavigation.tabBarItem = UITabBarItem(title: "Favories", image: UIImage(systemName: "heart.circle.fill"), tag: 1)
        favoriesCoordinator.parent = self
        
        navigation.viewControllers = [homeNavigation, favoriesNavigation, profileNavigation]
        
        childCoordinator.append(homeCoordinator)
        childCoordinator.append(favoriesCoordinator)
        childCoordinator.append(profileCoordinator)
        
        homeCoordinator.start()
        favoriesCoordinator.start()
        profileCoordinator.start()
    }
}
