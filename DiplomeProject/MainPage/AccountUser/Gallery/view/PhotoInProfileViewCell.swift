
import UIKit

protocol PhotoDelegate: AnyObject {
    func showAlbum()
}

class PhotoInProfileViewCell: UITableViewCell {

    static let shared = "PhotoInProfileViewCell"
    var imageProfile: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.photoCollection.reloadData()
            }
        }
    }
    weak var delegate: PhotoDelegate?
    
    lazy var photoLabel: UILabel = {
        let tilte = UILabel()
        tilte.textHeader(19, .semibold)
        return tilte
    }()

    private lazy var arrowButton: UIButton = {
        let arrow = UIButton(type: .system)
        arrow.setImage(UIImage(systemName: "chevron.right.circle"), for: .normal)
        arrow.tintColor = .systemOrange
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.addTarget(self, action: #selector(showAlbum), for: .touchUpInside)
        return arrow
    }()

    private lazy var photoCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        contentView.addSubview(photoLabel)
        contentView.addSubview(arrowButton)
        contentView.addSubview(photoCollection)
        
        layoutContraintes()
    }
    
    private func layoutContraintes() {
        NSLayoutConstraint.activate([

            photoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            photoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            arrowButton.centerYAnchor.constraint(equalTo: photoLabel.centerYAnchor),
            arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            photoCollection.topAnchor.constraint(equalTo: photoLabel.bottomAnchor),
            photoCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            photoCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            photoCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoCollection.heightAnchor.constraint(equalToConstant: 110),
        ])
    }
    
    @objc private func showAlbum() {
        delegate?.showAlbum()
    }
}

extension PhotoInProfileViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageProfile.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.shared, for: indexPath) as! PhotoViewCell
        cell.photoImage.image = imageProfile[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}
