
import CoreData
import UIKit


final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private let entity = "User"
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var viewContext: NSManagedObjectContext {
        if let context = appDelegate?.persistentContainer.viewContext {
            return context
        } else {
            preconditionFailure()
        }
    }
    
    func createAlbum(_ nameGalerry: String, account: User) {
        let gallery = Gallery(context: viewContext)
        gallery.name = nameGalerry
        account.addToGallery(gallery)
        
        save()
    }
    
    func createImage(_ album: Gallery?, imagePic: Data, account: User) {
        let image = Images(context: viewContext)
        image.photo = imagePic
        image.dateCreated = Date()
        if let album {
            album.addToImage(image)
            account.addToPhoto(image)
        }
        account.addToPhoto(image)
        save()
    }
    
    func savePost(_ text: String, imagePost: Data, account: User) {
        let post = Post(context: viewContext)
        post.text = text
        post.imagePost = imagePost
        post.dateCreated = Date()
        post.isFavorie = false
        account.addToPost(post)
        save()
    }
    
    func saveFavorie(_ article: Articles, account: User) {
        let favorie = Favories(context: viewContext)
        favorie.descriptionFavorie = article.description
        favorie.url = article.url
        favorie.publishedAt = article.publishedAt
        favorie.urlToImage = article.urlToImage
        
        account.addToFavorie(favorie)
        save()
    }
    
    func createAccount(_ uid: String, _ name: String, _ occuption: String, _ profilImage: Data) {
        guard let userEntity = NSEntityDescription.entity(forEntityName: entity, in: viewContext) else { return }
        let user = User(entity: userEntity, insertInto: viewContext)
        user.id = uid
        user.name = name
        user.occuption = occuption
        user.profileImage = profilImage

        save()
    }
    
    func fectchAccountUser(_ uid: String) -> User? {
        let fectchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fectchRequest.predicate = NSPredicate(format: "id=%@", uid)
        
        do {
            let result = try viewContext.fetch(fectchRequest).first
            return result as? User
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetAllPost(account: User) -> [Post] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "(isFavorie == false AND user = %@)", account)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        var resultPosts: [Post] = []
        
        do {
            resultPosts = try viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        return resultPosts
    }
    
    func fetAllImages(account: User) -> [Images] {
        let request: NSFetchRequest<Images> = Images.fetchRequest()
        request.predicate = NSPredicate(format: "user = %@", account)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Images.dateCreated), ascending: false)]
        
        var resultImages: [Images] = []
        
        do {
            resultImages = try viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        return resultImages
    }
    
    func deletePost(post: Post) {
        viewContext.delete(post)
        save()
    }
    
    func currentDataUpdate(_current: User) {
        let newValue = User(context: viewContext)
        
        newValue.name = _current.name
        newValue.occuption = _current.occuption
        newValue.profileImage = _current.profileImage
        newValue.city = _current.city
        newValue.birthDay = _current.birthDay
        
        save()
    }
    
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
