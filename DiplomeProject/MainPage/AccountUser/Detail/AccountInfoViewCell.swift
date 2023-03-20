
import UIKit

class AccountInfoViewCell: UITableViewCell {

    static let shared = "AccountInfoViewCelln"
    
    lazy var nameAccount: UILabel = {
       let name = UILabel()
        name.textHeader(17, .medium)
        return name
    }()
    
    lazy var imageSfSymbole: UIImageView = {
        let image = UIImageView()
        image.imageProfile()
        image.layer.cornerRadius = 30
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
            
            imageSfSymbole.widthAnchor.constraint(equalToConstant: 60),
            imageSfSymbole.heightAnchor.constraint(equalToConstant: 60),
            imageSfSymbole.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageSfSymbole.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            nameAccount.leadingAnchor.constraint(equalTo: imageSfSymbole.trailingAnchor, constant: 10),
            nameAccount.centerYAnchor.constraint(equalTo: imageSfSymbole.centerYAnchor),
            nameAccount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
            
        ])
    }

}
