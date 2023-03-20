
import UIKit

class FollowerProfileController: UIViewController {
    weak var coordinator: HomeCoordinator?
    
    var followerProfile: Account?
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.shared)
        tableview.register(PostRecorderTableViewCell.self, forCellReuseIdentifier: PostRecorderTableViewCell.shared)
        tableview.register(PhotoInProfileViewCell.self, forCellReuseIdentifier: PhotoInProfileViewCell.shared)
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
    
//    stackGroupCreateStackView
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = followerProfile?.name
        configuration()
    }
    
    private func configuration() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        let leftNavigation = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(openProfileFollower))
        leftNavigation.tintColor = .systemOrange
        
        navigationItem.leftBarButtonItem = leftNavigation
        layoutContraintes()
    }
    
    private func layoutContraintes() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func openProfileFollower() {
        navigationController?.popViewController(animated: true)
    }
}

extension FollowerProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return followerProfile?.post.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.shared, for: indexPath) as! HeaderTableViewCell
            
            cell.nameLabel.text = followerProfile?.name
            cell.occupationLabel.text = followerProfile?.occupation
            if let image = followerProfile?.image {
                cell.profileImage.image = UIImage(named: image)
            }
            
            cell.buttonDetail.isHidden = true
            cell.delegate = self
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostRecorderTableViewCell.shared, for: indexPath) as! PostRecorderTableViewCell
            
            cell.stackGroupePublicationStackView.isHidden = true
            
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoInProfileViewCell.shared, for: indexPath) as! PhotoInProfileViewCell
            
            cell.delegate = self
            
            let imageUser = followerProfile?.photoUser
            
            imageUser?.forEach { index in
                if let image = UIImage(named: index.name) {
                    cell.imageProfile.append(image)
                }
                cell.photoLabel.text = "Photographie  \(cell.imageProfile.count)"
            }
            return cell
            
            }
          else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PostViewCell.shared, for: indexPath) as! PostViewCell
            
            if let image = followerProfile?.image {
                cell.imageProfile.image = UIImage(named: image)
            }
            
            cell.nameLabel.text = followerProfile?.name
            cell.occupationLabel.text = followerProfile?.occupation
            
            if let post = followerProfile?.post {
                cell.postProfileUserConfiguration(with: (post[indexPath.row]))
            }
            
            return cell
        }
    }
}

extension FollowerProfileController: DetailProtocol, PhotoDelegate {
    
    func showAlbum() {
        let photoVc = GalleryController()
        followerProfile?.photoUser.forEach { index in
            if let image = UIImage(named: index.name) {
                photoVc.imagePicture.append(image)
            }
        }
        photoVc.addPhotoBarBotton.isHidden = true 
        navigationController?.present(photoVc, animated: true)
    }
    
    func showDetail() { }
    
    func showMessage() {
        //
    }
    
    func showCall() {
        //
    }
}
