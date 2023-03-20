
import UIKit


class DetailPageController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    
    private var account: User?
    private var viewModel: DetailViewModel!
        
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uid = UserDefaults.standard.string(forKey: "StateDidChangeListener") else { return }
        account = CoreDataManager.shared.fectchAccountUser(uid)
        configuration()
    }

    private func configuration() {
        
        let leftNavigation = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(returnToProfile))
        leftNavigation.tintColor = .systemOrange

        
        navigationItem.leftBarButtonItem = leftNavigation
        
        viewModel = DetailViewModel(delegate: self, account: account)
        
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
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
  

    @objc private func returnToProfile() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailPageController: DetailViewModelDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func changeImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func personelData() {
        coordinator?.personalInformation()
    }
    
    func signOut() {
        coordinator?.signOut()
    }
    
    func carrer() {
        //
    }
    
    func eduction() {
        //
    }
    
    func interests() {
        //
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        if let account {
            account.profileImage = image?.pngData()
            CoreDataManager.shared.currentDataUpdate(_current: account)
            self.tableView.reloadData()
        }
        dismiss(animated: true)
    }
}
