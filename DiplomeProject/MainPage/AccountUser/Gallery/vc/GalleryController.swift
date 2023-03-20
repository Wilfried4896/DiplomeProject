
import UIKit
import Photos
import PhotosUI

class GalleryController: UIViewController {

    private enum ConstantInterval {
        static let instant: CGFloat = 3
    }
    
    var imagePicture: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var account: User?
    
    lazy var numberImage: UILabel = {
        let number = UILabel()
        number.textHeader(16, .semibold)
        return number
    }()
    
    lazy var addPhotoBarBotton: UIBarButtonItem = {
        let addPhoto = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
        addPhoto.tintColor = .systemOrange
        return addPhoto
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(GalleryViewCell.self, forCellWithReuseIdentifier: GalleryViewCell.shared)
        collection.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.shared)
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photographie"
        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        guard let uid = UserDefaults.standard.string(forKey: "StateDidChangeListener") else { return }
        account = CoreDataManager.shared.fectchAccountUser(uid)
        
    }
    
    private func configuration() {
        view.backgroundColor = .systemBackground
        
        let goBack = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(goToBack))
        goBack.tintColor = .systemOrange
        
        view.addSubview(collectionView)
        
        navigationItem.rightBarButtonItem = addPhotoBarBotton
        navigationItem.leftBarButtonItem = goBack
                
        layoutContraints()
    }
    
    private func layoutContraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func addNewPhoto() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 2
        config.filter = .images
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension GalleryController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePicture.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.shared, for: indexPath) as! PhotoViewCell
        cell.photoImage.image = imagePicture[indexPath.item]
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        let inset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero

        let needWidth = collectionView.bounds.width - (ConstantInterval.instant - 1)  * spacing - inset.left - inset.right
        let itemWight = floor(needWidth / ConstantInterval.instant)
        
        return CGSize(width: itemWight, height: itemWight)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { contect -> UIMenu? in
            let imageGallery = self.imagePicture[indexPath.item]
            
            let deleteAction = UIAction(title: "Delete",
                                        image: UIImage(systemName: "trash"),
                                        identifier: nil,
                                        attributes: .destructive) { action in
                self.imagePicture.removeAll(where: {$0 == imageGallery})
            }
            return UIMenu(title: "", image: nil, children: [deleteAction])
        }
    }
}

extension GalleryController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var imageData = Data()
        
        let group = DispatchGroup()
        
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer {
                    group.leave()
                }
                
                guard let imageResult = reading as? UIImage, error == nil else { return }
                
                if let img = imageResult.pngData() {
                    imageData = img
                }
            }
        }
        group.notify(queue: .main) {
            if let account = self.account, let image = UIImage(data: imageData) {
                self.imagePicture.append(image)
                CoreDataManager.shared.createImage(nil, imagePic: imageData, account: account)
            }
        }
    }
}
