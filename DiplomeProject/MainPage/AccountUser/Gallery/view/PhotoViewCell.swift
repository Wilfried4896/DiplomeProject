
import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    static let shared = "PhotoViewCell"
    
    lazy var photoImage: UIImageView = {
        let arrow = UIImageView()
        arrow.layer.cornerRadius = 8
        arrow.imagePost()
        return arrow
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        contentView.addSubview(photoImage)
        
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
