
import UIKit
import Combine

class HomeController: UIViewController {
    weak var coordinator: HomeCoordinator?
    
    let service = HomeViewModel()
    var cancelled = Set<AnyCancellable>()
    private var articles: [Articles] = []
    
    var followers: [Account] = Users.shared.followers
    private var account: [Account] = []
    private var index = 0
        
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 40
        tableview.register(PostViewCell.self, forCellReuseIdentifier: PostViewCell.shared)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.backgroundColor = .systemBackground
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    lazy var activityIndicatorTabl: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "News"
        configuration()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPublishers()
        
    }
    
    private func configuration() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.addSubview(activityIndicatorTabl)

        layoutConfiguration()
    }
    
    private func setupPublishers() {
            service.$state
                .sink { [weak self] state in
                    switch state {
                    case .loading:
                        self?.activityIndicatorTabl.startAnimating()
                    case .success(articles: let articles):
                        self?.activityIndicatorTabl.stopAnimating()
                        self?.articles = articles
                        self?.tableView.reloadData()
                        self?.index = self?.articles.count ?? 0
                    case .failed(error: let error):
                        self?.alertMessage(error.localizedDescription)
                    case .none:
                        break
                    }
                }
                .store(in: &cancelled)
    }
    
    private func layoutConfiguration() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicatorTabl.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicatorTabl.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }
}

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostViewCell.shared, for: indexPath) as! PostViewCell
        cell.setSelected(true, animated: true)
        
        cell.postConfiguration(with: articles[indexPath.row])
        
        repeat {
            let follower = followers.randomElement()!
            account.append(follower)
            if index == articles.count {
                break
            }
        } while index != articles.count
        
        cell.imageProfile.image = UIImage(named: account[indexPath.row].image)
        cell.nameLabel.text = account[indexPath.row].name
        cell.occupationLabel.text = account[indexPath.row].occupation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = ShowPublicationController()

        show.account = account[indexPath.row]
        show.article = articles[indexPath.row]
        
        navigationController?.pushViewController(show, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions -> UIMenu? in
            let article = self.articles[indexPath.row]
            
            let copyAction = UIAction(title: "Copy",
                                      image: UIImage(systemName: "doc.on.doc"),
                                      identifier: nil, discoverabilityTitle: nil) { action in
                if let url = article.url {
                    UIPasteboard.general.string = url
                }
            }
            let favorisAction = UIAction(title: "Favorie",
                                         image: UIImage(systemName: "heart.fill"), identifier: nil,
                                         state: .off) { action in
                //
            }
            let unFavorisAction = UIAction(title: "Unfavorie",
                                         image: UIImage(systemName: "heart.slash.fill"), identifier: nil,
                                         state: .on) { action in
                //
            }
            
           // let favAvtion: UIAction = post.isFavorie ? unFavorisAction : favorisAction
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [copyAction])
        }
    }
}
