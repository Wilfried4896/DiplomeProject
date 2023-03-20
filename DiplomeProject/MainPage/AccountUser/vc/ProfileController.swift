
import UIKit
import CoreData

class ProfileController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    var account: User?
    
    private var favorites: Set<String> = []
    
    var postsAccount: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var indexPost: Int = 0
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.shared)
        tableview.register(PostRecorderTableViewCell.self, forCellReuseIdentifier: PostRecorderTableViewCell.shared)
        tableview.register(PhotoInProfileViewCell.self, forCellReuseIdentifier: PhotoInProfileViewCell.shared)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.register(PostViewCell.self, forCellReuseIdentifier: PostViewCell.shared)
        tableview.estimatedRowHeight = 40
        tableview.rowHeight = UITableView.automaticDimension
        tableview.separatorInset = UIEdgeInsets.zero
        tableview.preservesSuperviewLayoutMargins = false
        tableview.layoutMargins = UIEdgeInsets.zero
        tableview.showsVerticalScrollIndicator = false
        tableview.allowsSelection = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uid = UserDefaults.standard.string(forKey: "StateDidChangeListener") else { return }
        self.account = CoreDataManager.shared.fectchAccountUser(uid)
        self.tableView.reloadData()
        
        if let account {
            postsAccount = CoreDataManager.shared.fetAllPost(account: account)
        }
    }
    
    private func configuration() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
                
        layoutContraints()
    }
 
    private func layoutContraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return postsAccount.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.shared, for: indexPath) as! HeaderTableViewCell
            
            if let account {
                cell.setConfiguration(account: account)
            }
            
            cell.delegate = self
            cell.stackButton.isHidden = true
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostRecorderTableViewCell.shared, for: indexPath) as! PostRecorderTableViewCell
            cell.delegate = self
            cell.publicationButton.postRecorder("\t\(postsAccount.count)\nпубликаций")
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoInProfileViewCell.shared, for: indexPath) as! PhotoInProfileViewCell
            
            if let account, let imagesAccount = account.photo?.allObjects as? [Images] {
                var accountPicture: [UIImage] = []
                
                for index in 0..<imagesAccount.count {
                    if let image = imagesAccount[index].photo, let uiimage = UIImage(data: image){
                        accountPicture.append(uiimage)
                    }
                }
                
                cell.imageProfile = accountPicture
                cell.photoLabel.text = "Photographie \(account.photo?.count ?? 0)"
            }

            cell.delegate = self
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostViewCell.shared, for: indexPath) as! PostViewCell
            let object = postsAccount[indexPath.row]
            
            if let account, let name = account.name,
                let occuption = account.occuption,
                let image = account.profileImage {
                    
                cell.nameLabel.text = name
                cell.occupationLabel.text = occuption
                cell.imageProfile.image = UIImage(data: image)
            }
                
            if let image = object.imagePost, let text = object.text {
                cell.imagePost.image = UIImage(data: image)
                cell.textPostLabel.text = text
            }
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions -> UIMenu? in
            let post = self.postsAccount[indexPath.row]
            
            let copyAction = UIAction(title: "Copy",
                                      image: UIImage(systemName: "doc.on.doc"),
                                      identifier: nil, discoverabilityTitle: nil) { action in
                UIPasteboard.general.string = "\(post.text!)"
            }
            let favorisAction = UIAction(title: "Favorie",
                                         image: UIImage(systemName: "heart.fill"), identifier: nil,
                                         state: .off) { action in
                //
            }
            let unFavorisAction = UIAction(title: "Unfavorie",
                                         image: UIImage(systemName: "heart.slash.fill"), identifier: nil,
                                         state: .on) { action in
                post.isFavorie = false
            }
            let deleteAction = UIAction(title: "Delete",
                                        image: UIImage(systemName: "trash"),
                                        identifier: nil, attributes: .destructive) { action in
                self.postsAccount.removeAll(where: {$0.text == post.text})
                CoreDataManager.shared.deletePost(post: post)
                self.tableView.reloadData()
            }
            
            let favAvtion: UIAction = post.isFavorie ? unFavorisAction : favorisAction
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [copyAction, favAvtion, deleteAction])
        }
    }
}

extension ProfileController: PhotoDelegate, DetailProtocol, PostRecorderProtocol {
 
    func showMessage() { }
    
    func showCall() { }
    
    
    func createNewPost() {
        coordinator?.createNewPost()
    }
    
    func showDetail() {
        coordinator?.detail()
    }
    
    func showAlbum() {
        let showGallery = GalleryController()

        if let account {
            let imagesFromCoreData = CoreDataManager.shared.fetAllImages(account: account)
            imagesFromCoreData.forEach { imageToCollection in
                if let image = imageToCollection.photo, let imageCollection = UIImage(data: image) {
                    if showGallery.imagePicture.contains(where: {$0 == imageCollection}) { } else {
                        showGallery.imagePicture.append(imageCollection)
                    }
                }
            }
        }
        navigationController?.pushViewController(showGallery, animated: true)
    }
}
