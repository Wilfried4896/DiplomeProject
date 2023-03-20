
import UIKit
import Combine

protocol PostViewCellProtocol: AnyObject {
    func openProfile()
}

class PostViewCell: UITableViewCell {
    static let shared = "PostViewCell"
    var cancelled = Set<AnyCancellable>()
    let service = HomeViewModel()
    
    weak var delegate: PostViewCellProtocol?
    
    lazy var imageProfile: UIImageView = {
        let image = UIImageView()
        image.imageProfile()
        image.layer.cornerRadius = 40
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.text = "Name Familly"
        name.textHeader(17, .semibold)
        return name
    }()
    
    lazy var occupationLabel: UILabel = {
        let occupation = UILabel()
        occupation.textHeader(14, .medium)
        return occupation
    }()
    
    lazy var textPostLabel: UILabel = {
        let text = UILabel()
        text.textHeader(14, .medium)
        text.text = "Stocks drifted to a mixed close Monday as Wall Street remained in a holding pattern ahead of a potentially big week. The S&P 500 rose 2.78 points, or 0.1%, to 4,048.42 after coming off its first winning week in the last four."
        text.numberOfLines = 2
        text.isUserInteractionEnabled = true
        return text
    }()
    
    lazy var imagePost: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo.on.rectangle.angled")
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        image.imagePost()
        return image
    }()
    
    lazy var activityIndicatorImag: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(named: "TextColor")
        return indicator
    }()
    
    lazy var likesPost: UILabel = {
        let like = UILabel()
        like.textHeader(14, .medium)
        return like
    }()
    
    lazy var imageLikes: UIImageView = {
        let image = UIImageView()
        image.likesVuesImages("heart")
        return image
    }()
    
    lazy var messagePost: UILabel = {
        let vue = UILabel()
        vue.textHeader(14, .medium)
        return vue
    }()
    
    lazy var imageMessage: UIImageView = {
        let image = UIImageView()
        image.likesVuesImages("message")
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
                
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageProfile)
        contentView.addSubview(occupationLabel)
        contentView.addSubview(textPostLabel)
        contentView.addSubview(imagePost)
        contentView.addSubview(activityIndicatorImag)
        
        let openProfileUserTap = UITapGestureRecognizer(target: self, action: #selector(openProfileUser))
        openProfileUserTap.numberOfTapsRequired = 1
        
        if occupationLabel.text == "" {
            occupationLabel.text = "Occupation: - "
        }
        
        imageProfile.addGestureRecognizer(openProfileUserTap)
        
        activityIndicatorImag.isHidden = true
        
        layoutContraints()
    }
    
    private func layoutContraints() {
        let stackLikes = UIStackView(arrangedSubviews: [likesPost, imageLikes])
        stackLikes.spacing = 5
        stackLikes.translatesAutoresizingMaskIntoConstraints = false
        stackLikes.axis = .horizontal

        let stackMessage = UIStackView(arrangedSubviews: [messagePost, imageMessage])
        stackMessage.spacing = 5
        stackMessage.translatesAutoresizingMaskIntoConstraints = false
        stackLikes.axis = .horizontal

        let stackgroup = UIStackView(arrangedSubviews: [stackLikes, stackMessage])
        stackgroup.spacing = 10
        stackgroup.translatesAutoresizingMaskIntoConstraints = false
        stackLikes.axis = .horizontal
        
        contentView.addSubview(stackgroup)
        
        NSLayoutConstraint.activate([
            imageProfile.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageProfile.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageProfile.heightAnchor.constraint(equalToConstant: 80),
            imageProfile.widthAnchor.constraint(equalToConstant: 80),
            
            
            nameLabel.leadingAnchor.constraint(equalTo: imageProfile.trailingAnchor, constant: 13),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),

            occupationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            occupationLabel.leadingAnchor.constraint(equalTo: imageProfile.trailingAnchor, constant: 13),
            
            textPostLabel.topAnchor.constraint(equalTo: occupationLabel.bottomAnchor, constant: 25),
            textPostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textPostLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        
            
            imagePost.topAnchor.constraint(equalTo: textPostLabel.bottomAnchor, constant: 10),
            imagePost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagePost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagePost.heightAnchor.constraint(equalToConstant: contentView.frame.width),
            
            activityIndicatorImag.centerYAnchor.constraint(equalTo: imagePost.centerYAnchor),
            activityIndicatorImag.centerXAnchor.constraint(equalTo: imagePost.centerXAnchor),
            
            stackgroup.topAnchor.constraint(equalTo: imagePost.bottomAnchor, constant: 5),
            stackgroup.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackgroup.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackgroup.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
        ])
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(deleteRow)
    }
    
    @objc func deleteRow() {
        print(#function)
    }
    
    @objc private func openProfileUser() {
        delegate?.openProfile()
    }
    
    func postConfiguration(with articles: Articles) {

        activityIndicatorImag.isHidden = false
        
        textPostLabel.text = articles.description
        if let urlImage = articles.urlToImage {
            service.getUrlImage(urlImage) { imgaeData in
                self.imagePost.image = UIImage(data: imgaeData)
            }
        }
        
        service.$stateImag
            .sink { state in
                switch state {
                case .loading:
                    self.activityIndicatorImag.startAnimating()
                case .success:
                    self.activityIndicatorImag.stopAnimating()
                case .failed(error: let error):
                    print(error.localizedDescription)
                case .none:
                    break
                }
            }
            .store(in: &cancelled)
    }
    
    func postProfileUserConfiguration(with post: Posts) {
        activityIndicatorImag.isHidden = false
        
        textPostLabel.text = post.text
        
        service.getUrlImage(post.image) { imgaData in
            self.imagePost.image = UIImage(data: imgaData)
        }
        
        
        service.$stateImag
            .sink { state in
                switch state {
                case .loading:
                    self.activityIndicatorImag.startAnimating()
                case .success:
                    self.activityIndicatorImag.stopAnimating()
                case .failed(error: let error):
                    print(error.localizedDescription)
                case .none:
                    break
                }
            }
            .store(in: &cancelled)
    }
    
}

