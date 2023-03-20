
import UIKit

class AuthCoordinator: Coordinator {
    weak var parent: AppCoordinator?
    var childCoordinator: [Coordinator] = []
    
    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        loginPage()
    }
    
    func loginPage() {
        let loginVc = LoginController()
        loginVc.coordinator = self
        navigation.pushViewController(loginVc, animated: false)
    }
    
    func registrationPage() {
        let register = RegistrationController()
        register.coordinator = self
        let navigationFullScreen = UINavigationController(rootViewController: register)
        navigationFullScreen.modalPresentationStyle = .fullScreen
        navigation.present(navigationFullScreen, animated: true)
    }
}
