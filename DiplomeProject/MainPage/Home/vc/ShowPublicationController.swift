
import UIKit
import Combine

class ShowPublicationController: UIViewController {
    
    var article: Articles?
    var account: Account?
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.register(PostViewCell.self, forCellReuseIdentifier: PostViewCell.shared)
        tableview.estimatedRowHeight = 40
        tableview.rowHeight = UITableView.automaticDimension
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
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configuration() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
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
}

extension ShowPublicationController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostViewCell.shared, for: indexPath) as! PostViewCell
        
        if let account, let article {
            cell.imageProfile.image = UIImage(named: account.image)
            cell.occupationLabel.text = account.occupation
            cell.nameLabel.text = account.name
            
            cell.textPostLabel.numberOfLines = 0
            cell.postConfiguration(with: article)
        }
        cell.delegate = self
        
        return cell
    }
}


extension ShowPublicationController: PostViewCellProtocol {
    func openProfile() {
        let followeInfo = FollowerProfileController()
        if let account {
            followeInfo.followerProfile = account
        }
        navigationController?.pushViewController(followeInfo, animated: true)
    }
}

