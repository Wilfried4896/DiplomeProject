
import UIKit
import Firebase
import FirebaseAuth

public var account: User?

class AppCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    
    var window: UIWindow?
    var navigation: UIViewController?
    var handler: AuthStateDidChangeListenerHandle?
    
    init(window: UIWindow?) {
        self.window = window
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        
    }
    
    func start() {
        handler = Auth.auth().addStateDidChangeListener({ resp, user in
            if user != nil {
                self.mainPage()
            } else {
                self.authentificationPage()
            }
            if let uid = user?.uid {
                UserDefaults.standard.set(uid, forKey: "StateDidChangeListener")
            }
        })
    }
    
    func mainPage() {
        navigation = UITabBarController()
        window?.rootViewController = navigation
        
        let mainCoordinator = MainCoordinator(navigation: navigation as! UITabBarController)
        mainCoordinator.parent = self
        childCoordinator.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    
    func authentificationPage() {
        navigation = UINavigationController()
        window?.rootViewController = navigation
        
        let authenCoordinator = AuthCoordinator(navigation: navigation as! UINavigationController)
        authenCoordinator.parent = self
        childCoordinator.append(authenCoordinator)
        authenCoordinator.start()
    }
}
