
import UIKit
import CoreData

protocol FavorieViewModelProtocol: AnyObject {
    func reloadData(with: FavorieViewModel)
}

class FavorieViewModel: NSObject, NSFetchedResultsControllerDelegate {
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    weak var delegate: FavorieViewModelProtocol?
    
    private var fetchController: NSFetchedResultsController<Post>?
    
    func receiveFromCoreData() {
        
        guard let uid = UserDefaults.standard.string(forKey: "StateDidChangeListener") else { return }
        let account = CoreDataManager.shared.fectchAccountUser(uid)
        
        if let context = container?.viewContext, let account {
            let request: NSFetchRequest<Post> = Post.fetchRequest()
            request.predicate = NSPredicate(format: "(isFavorie == true AND user = %@)", account)
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Post.dateCreated), ascending: false)]
            fetchController = NSFetchedResultsController(fetchRequest: request,
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)
            
            fetchController?.delegate = self
            do {
                try fetchController?.performFetch()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData(with: self)
    }
    
    func numberOfRow(section: Int) -> Int {
        return fetchController?.sections?[section].numberOfObjects ?? 0
    }
    
    func object(indexPath: IndexPath) -> Post? {
        return fetchController?.object(at: indexPath)
    }
}
