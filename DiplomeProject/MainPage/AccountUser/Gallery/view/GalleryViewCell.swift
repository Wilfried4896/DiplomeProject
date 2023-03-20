
import UIKit

class GalleryViewCell: UICollectionViewCell {
    
    static let shared = "GalleryViewCell"
    
    private enum Content {
        static let instant: CGFloat = 2
    }
    
    private var indexShow: Int = 2 {
        didSet {
            DispatchQueue.main.async {
                self.galleryCollection.reloadData()
            }
        }
    }
    
    var galleryAlbum: [Gallery] = []
    
    private lazy var galleryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.allowsSelection = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.shared)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var showAllAlbumButton: UIButton = {
        let showAllAlbum = UIButton(type: .system)
        showAllAlbum.addTarget(self, action: #selector(showAllAlbumPicture), for: .touchUpInside)
        showAllAlbum.translatesAutoresizingMaskIntoConstraints = false
        showAllAlbum.tintColor = .systemOrange
        showAllAlbum.setTitle("Show All Album", for: .normal)
        showAllAlbum.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return showAllAlbum
    }()
    
    private lazy var albumLabel: UILabel = {
        let album = UILabel()
        album.textHeader(14, .semibold)
        album.tintColor = .systemOrange
        return album
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        contentView.addSubview(galleryCollection)
        contentView.addSubview(showAllAlbumButton)
        contentView.addSubview(albumLabel)
        
        albumLabel.text = "Album"
        layoutContraintes()
    }
    
    private func layoutContraintes() {
        
        NSLayoutConstraint.activate([
            
            showAllAlbumButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            showAllAlbumButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            albumLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            galleryCollection.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 10),
            galleryCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            galleryCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            galleryCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    @objc private func showAllAlbumPicture() {
        if indexShow == 2 {
            showAllAlbumButton.setTitle("Show All Album", for: .normal)
            
        } else {
            showAllAlbumButton.setTitle("Show Less", for: .normal)
            indexShow = galleryAlbum.count
        }
    }
}

extension GalleryViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexShow
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.shared, for: indexPath) as! PhotoViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
        let inset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
            
        let needWight = collectionView.bounds.width - (Content.instant - 1) * spacing - inset.left - inset.right
        let itemWight = floor(needWight / Content.instant)
            
        return CGSize(width: itemWight, height: itemWight)
    }
}
