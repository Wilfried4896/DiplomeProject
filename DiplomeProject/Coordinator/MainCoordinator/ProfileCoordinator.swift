

import UIKit
import FirebaseAuth

class ProfileCoordinator: Coordinator {
    weak var parent: Coordinator?
    var navigation: UINavigationController
    
    var childCoordinator: [Coordinator] = []
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        profile()
    }
    
    func profile() {
        let profileVc = ProfileController()
        profileVc.coordinator = self
        navigation.pushViewController(profileVc, animated: true)
    }
    
    func albumPage() {
        let photoVc = GalleryController()
        navigation.pushViewController(photoVc, animated: true)
    }
    
    func detail() {
        let detailVc = DetailPageController()
        detailVc.coordinator = self
        navigation.pushViewController(detailVc, animated: true)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func personalInformation() {
        let personalVc = PersonalInformationUpdateController()
        personalVc.coordinator = self
        let navigationFull = UINavigationController(rootViewController: personalVc)
        navigationFull.modalPresentationStyle = .fullScreen
        navigation.present(navigationFull, animated: true)
    }
    
    
    func createNewPost() {
        let postVc = CreatePostController()
        postVc.coordinator = self
        let navigationScreen = UINavigationController(rootViewController: postVc)
        navigationScreen.modalPresentationStyle = .fullScreen
        navigation.present(navigationScreen, animated: true)
    }
}
