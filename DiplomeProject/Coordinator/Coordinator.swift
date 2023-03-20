
import Foundation

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    func start()
}


extension Coordinator {
    
    func childrenFinish(_ coordinator: Coordinator) {
        
        for (index, child) in childCoordinator.enumerated() {
            if child === coordinator {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
}
