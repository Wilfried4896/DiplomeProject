
import UIKit
import Photos
import PhotosUI
import SnapKit

class CreatePostController: UIViewController {

    weak var coordinator: ProfileCoordinator?
    var account: User?
    
    var imageData: [Data] = []
    var imageSelected: [UIImage] = []
    
    lazy var postTextView: UITextView = {
        let text = UITextView()
        return text
    }()
    
    lazy var doneButton: UIBarButtonItem = {
       let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        done.tintColor = .systemOrange
        return done
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.layer.cornerRadius = 10
        scroll.delegate = self
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create new post"
        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uid = UserDefaults.standard.string(forKey: "StateDidChangeListener") else { return }
        DispatchQueue.main.async { [weak self] in
            self?.account = CoreDataManager.shared.fectchAccountUser(uid)
        }
    }
    
    private func configuration() {
        view.backgroundColor = .systemBackground
        view.addSubview(postTextView)
        view.addSubview(scrollView)
        
        doneButton.isEnabled = true
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButton))
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButton))
        cameraButton.tintColor = .systemOrange
        
        postTextView.keyboardDismissMode = .interactive
        navigationItem.leftBarButtonItem = cameraButton
        navigationItem.rightBarButtonItems = [closeButton, doneButton]
        
        postTextView.backgroundColor = .secondarySystemBackground
        
        layoutContraintes()
    }
    
    private func layoutContraintes() {
        let safeArea = view.safeAreaLayoutGuide
        
        postTextView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(5)
            make.top.equalTo(safeArea).inset(5)
            make.height.equalTo(200)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(postTextView.snp.bottom).offset(20)
            make.height.equalTo(200)
        }
    }
    
    @objc private func doneAction() {
        if imageData.isEmpty && postTextView.text == "" {
            self.alertMessage("Not informations")
        } else {
            doneButton.isEnabled = false
            if let image = imageData.first, let text = postTextView.text, let account {
                CoreDataManager.shared.savePost(text, imagePost: image, account: account)
            }
            
            dismiss(animated: true)
        }
    }
    
    @objc private func cameraButton() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = .images
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    @objc private func closeButton() {
        dismiss(animated: true)
    }
}

extension CreatePostController: PHPickerViewControllerDelegate, UIScrollViewDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        self.imageSelected = []
        self.imageData = []
        
        let group = DispatchGroup()
        
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                defer {
                    group.leave()
                }
                
                guard let imageResult = reading as? UIImage, error == nil else { return }
                
                self?.imageSelected.append(imageResult)
                if let img = imageResult.pngData() {
                    self?.imageData.append(img)
                }
            }
        }
        group.notify(queue: .main) {
            for index in 0..<self.imageSelected.count {
                let imageView = UIImageView()
                imageView.image = self.imageSelected[index]
                imageView.contentMode = .scaleAspectFit
                let xPosition = self.scrollView.frame.width * CGFloat(index)
                imageView.frame = CGRect(x: xPosition,
                                         y: 0,
                                         width: self.scrollView.frame.width,
                                         height: self.scrollView.frame.height)
                
                self.scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(index + 1)
                self.scrollView.addSubview(imageView)
            }
        }
    }
}
