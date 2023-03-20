
import UIKit

class ParametersViewCell: UITableViewCell {
    
    static let shared = "ParametersViewCell"
    
    lazy var nameAccount: UILabel = {
       let name = UILabel()
        name.textHeader(15, .medium)
        return name
    }()
    
    lazy var imageSfSymbole: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        contentView.addSubview(nameAccount)
        contentView.addSubview(imageSfSymbole)
        
        NSLayoutConstraint.activate([
            
            imageSfSymbole.widthAnchor.constraint(equalToConstant: 40),
            imageSfSymbole.heightAnchor.constraint(equalToConstant: 40),
            imageSfSymbole.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageSfSymbole.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            nameAccount.leadingAnchor.constraint(equalTo: imageSfSymbole.trailingAnchor, constant: 10),
            nameAccount.centerYAnchor.constraint(equalTo: imageSfSymbole.centerYAnchor),
            nameAccount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
            
        ])
    }
    
}
