
import UIKit

protocol PostRecorderProtocol: AnyObject {
    func createNewPost()
}

class PostRecorderTableViewCell: UITableViewCell {
    
    static let shared = "PostRecorderTableViewCell"
    weak var delegate: PostRecorderProtocol?
    let spacingVertical = CGFloat(5)
    
    lazy var stackPhotoStackView: UIStackView = {
        let stackPhoto = UIStackView()
        stackPhoto.postVertical(spacingVertical)
        return stackPhoto
    }()
    
    lazy var stackHistoryStackView: UIStackView = {
        let stackHistory = UIStackView()
        stackHistory.postVertical(spacingVertical)
        return stackHistory
    }()
    
    lazy var stackPostStackView: UIStackView = {
        let stackPost = UIStackView()
        stackPost.postVertical(spacingVertical)
        return stackPost
    }()
    
    lazy var stackGroupePublicationStackView: UIStackView = {
        let stackGroupePublication = UIStackView()
        stackGroupePublication.postHorizontal()
        return stackGroupePublication
    }()
    
    lazy var stackGroupCreateStackView: UIStackView = {
        let stackGroupCreate = UIStackView()
        stackGroupCreate.postHorizontal()
        return stackGroupCreate
    }()
    
    lazy var publicationButton: UIButton = {
        let publication = UIButton(type: .system)
        publication.postRecorder("\t0\nпубликаций")
        return publication
    }()
    
    lazy var followersButton: UIButton = {
        let followers = UIButton(type: .system)
        followers.postRecorder("\t12\nподписок")
        return followers
    }()
    
    lazy var followingsButton: UIButton = {
        let followings = UIButton(type: .system)
        followings.postRecorder("\t120\nподписчиков")
        return followings
    }()
    
    lazy var createPostButton: UIButton = {
        let createPost = UIButton(type: .system)
        createPost.createPostIcon("square.and.pencil")
        createPost.addTarget(self, action: #selector(newPost), for: .touchUpInside)
        return createPost
    }()
    
    lazy var createPostLabel: UILabel = {
        let createPost = UILabel()
        createPost.tintColor = UIColor(named: "TextColor")
        createPost.text = "Post"
        createPost.textHeader(14, .regular)
        return createPost
    }()
    
    lazy var createHistoryButton: UIButton = {
        let createHistory = UIButton(type: .system)
        createHistory.createPostIcon("camera")
        return createHistory
    }()
    
    lazy var createHistorLabel: UILabel = {
        let createHistory = UILabel()
        createHistory.tintColor = UIColor(named: "TextColor")
        createHistory.text = "History"
        createHistory.textHeader(14, .regular)
        return createHistory
    }()
    
    lazy var photoButton: UIButton = {
        let photo = UIButton(type: .system)
        photo.createPostIcon("photo")
        return photo
    }()
    
    lazy var photoLabel: UILabel = {
        let photo = UILabel()
        photo.tintColor = UIColor(named: "TextColor")
        photo.text = "Photo"
        photo.textHeader(14, .regular)
        return photo
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configuration() {
        stackPhotoStackView.addArrangedSubview(photoButton)
        stackPhotoStackView.addArrangedSubview(photoLabel)
        
        stackHistoryStackView.addArrangedSubview(createHistoryButton)
        stackHistoryStackView.addArrangedSubview(createHistorLabel)
        
        stackPostStackView.addArrangedSubview(createPostButton)
        stackPostStackView.addArrangedSubview(createPostLabel)
        
        stackGroupePublicationStackView.addArrangedSubview(stackPostStackView)
        stackGroupePublicationStackView.addArrangedSubview(stackPhotoStackView)
        stackGroupePublicationStackView.addArrangedSubview(stackHistoryStackView)
        
        stackGroupCreateStackView.addArrangedSubview(publicationButton)
        stackGroupCreateStackView.addArrangedSubview(followersButton)
        stackGroupCreateStackView.addArrangedSubview(followingsButton)
        
        contentView.addSubview(stackGroupePublicationStackView)
        contentView.addSubview(stackGroupCreateStackView)
        
        NSLayoutConstraint.activate([
         
            stackGroupCreateStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackGroupCreateStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackGroupCreateStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                        
            stackGroupePublicationStackView.topAnchor.constraint(equalTo: stackGroupCreateStackView.bottomAnchor, constant: 20),
            stackGroupePublicationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            stackGroupePublicationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            stackGroupePublicationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    @objc private func newPost() {
        delegate?.createNewPost()
    }
    
}
