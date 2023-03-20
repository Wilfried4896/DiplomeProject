
import UIKit

protocol DetailProtocol: AnyObject {
    func showDetail()
    func showMessage()
    func showCall()
}

class HeaderTableViewCell: UITableViewCell {
    weak var delegate: DetailProtocol?
    
    static let shared = "HeaderTableViewCell"
    
    lazy var stackButton: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.imageProfile()
        image.layer.cornerRadius = 50
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.textHeader(18, .semibold)
        name.text = " "
        return name
    }()
    
    lazy var cityLabel: UILabel = {
        let city = UILabel()
        city.textHeader(14, .medium)
        city.text = "I live in ?"
        return city
    }()
    
    lazy var occupationLabel: UILabel = {
        let occupation = UILabel()
        occupation.textHeader(12, .medium)
        occupation.text = "I'm ?"
        return occupation
    }()
    
    lazy var buttonDetail: UIButton = {
        let detail = UIButton(type: .system)
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.setTitle("More information", for: .normal)
        detail.tintColor = .white
        detail.backgroundColor = .systemOrange
        detail.layer.cornerRadius = 10
        detail.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        detail.addTarget(self, action: #selector(showDetailPage), for: .touchUpInside)
        return detail
    }()
    
    lazy var buttonMessage: UIButton = {
        let detail = UIButton(type: .system)
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.setTitle("Message", for: .normal)
        detail.tintColor = .white
        detail.backgroundColor = .systemOrange
        detail.layer.cornerRadius = 10
        detail.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        detail.addTarget(self, action: #selector(showCallPage), for: .touchUpInside)
        return detail
    }()
    
    lazy var buttonCall: UIButton = {
        let detail = UIButton(type: .system)
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.setTitle("Call", for: .normal)
        detail.tintColor = .white
        detail.backgroundColor = .systemOrange
        detail.layer.cornerRadius = 10
        detail.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        detail.addTarget(self, action: #selector(showMessagePage), for: .touchUpInside)
        return detail
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(occupationLabel)
        contentView.addSubview(buttonDetail)
        contentView.addSubview(cityLabel)
        contentView.addSubview(stackButton)
        stackButton.addArrangedSubview(buttonMessage)
        stackButton.addArrangedSubview(buttonCall)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.widthAnchor.constraint(equalToConstant: 100),

            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 13),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),

            occupationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            occupationLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 13),
            
            cityLabel.topAnchor.constraint(equalTo: occupationLabel.bottomAnchor, constant: 7),
            cityLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 13),
            
            buttonDetail.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            buttonDetail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonDetail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            buttonDetail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonDetail.heightAnchor.constraint(equalToConstant: 50),
            
            stackButton.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            stackButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func showDetailPage() {
        delegate?.showDetail()
    }
    
    @objc private func showMessagePage() {
        delegate?.showMessage()
    }
    
    @objc private func showCallPage() {
        delegate?.showCall()
    }
    
    
    func setConfiguration(account: User) {
        nameLabel.text = account.name
        occupationLabel.text = "I'm \(account.occuption ?? "")"
        cityLabel.text = "I live in \(account.city ?? "")"
        
        
        if let image = account.profileImage {
            profileImage.image = UIImage(data: image)
        }
    }
}
