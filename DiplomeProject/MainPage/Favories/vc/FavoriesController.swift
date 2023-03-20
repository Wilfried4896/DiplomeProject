
import UIKit

class FavoriesController: UIViewController, FavorieViewModelProtocol {
    func reloadData(with: FavorieViewModel) {
        tableView.reloadData()
    }
    
    weak var coordinator: FavoriesCoordinator?
    private let favorieVM = FavorieViewModel()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 40
        tableview.register(PostViewCell.self, forCellReuseIdentifier: PostViewCell.shared)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.allowsSelection = false
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorieVM.delegate = self
        favorieVM.receiveFromCoreData()
        configuration()
    }
 
    
    private func configuration() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        navigationItem.title = "Favories"
        navigationController?.navigationBar.prefersLargeTitles = true
        layoutContraintes()
    }
    
    private func layoutContraintes() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


extension FavoriesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorieVM.numberOfRow(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostViewCell.shared, for: indexPath) as! PostViewCell
        let object = favorieVM.object(indexPath: indexPath)
        if let object, let image = object.imagePost {
            cell.textPostLabel.text = object.text
            cell.imagePost.image = UIImage(data: image)
        }
        return cell
    }
}
