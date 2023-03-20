
import UIKit
import Combine

class RegistrationController: UIViewController {
    weak var coordinator: AuthCoordinator?
    
    let scrollView = UIScrollView()
    var cancelled = Set<AnyCancellable>()
    let registerViewModel = RegisterViewModel()
    var imageData = Data()
    
    lazy var imageProfil: UIImageView = {
        let image = UIImageView()
        image.imageProfile()
        image.layer.cornerRadius = 60
        return image
    }()
    
    lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.customField(_keyboardType: .namePhonePad, _placeholder: "Name")
        return name
    }()
    
    lazy var occuptionTextField: UITextField = {
        let occuption = UITextField()
        occuption.customField(_keyboardType: .namePhonePad, _placeholder: "Occuption")
        return occuption
    }()
    
    lazy var emailTextField: UITextField = {
        let email = UITextField()
        email.customField(_keyboardType: .emailAddress, _placeholder: "Email")
        return email
    }()
    
    lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.customField(_keyboardType: .none, _placeholder: "Password")
        password.isSecureTextEntry = true
        return password
    }()
    
    lazy var singUpButton: UIButton = {
        let signUp = UIButton(type: .system)
        signUp.setTitle("Sign Up", for: .normal)
        signUp.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        signUp.backgroundColor = .systemOrange
        signUp.tintColor = .white
        signUp.layer.cornerRadius = 10
        signUp.addTarget(self, action: #selector(goToMainPage), for: .touchUpInside)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        return signUp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationRegistration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didHidekeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configurationRegistration() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Register"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(didChangedImage))
        tapGest.numberOfTapsRequired = 1
        imageProfil.addGestureRecognizer(tapGest)
        
        let tapKeyboard = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapKeyboard)
        
        let bottonClosed = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closedRegister))
        navigationItem.rightBarButtonItem = bottonClosed
            
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageProfil)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(occuptionTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(singUpButton)
     
        
        layoutContraints()
        setPublisher()
    }
    
    private func setPublisher() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: nameTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.name, on: registerViewModel)
            .store(in: &cancelled)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: occuptionTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.occupation, on: registerViewModel)
            .store(in: &cancelled)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.email, on: registerViewModel)
            .store(in: &cancelled)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.password, on: registerViewModel)
            .store(in: &cancelled)
        
        
        
        registerViewModel.isSubmit
            .assign(to: \.isEnabled, on: singUpButton)
            .store(in: &cancelled)
        
        registerViewModel.$state
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.singUpButton.isEnabled = false
                case .success:
                    self?.singUpButton.isEnabled = true
                case .failed:
                    break
                case .none:
                    break
                }
            }
            .store(in: &cancelled)
            
    }
    
    private func layoutContraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageProfil.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageProfil.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            imageProfil.widthAnchor.constraint(equalToConstant: 120),
            imageProfil.heightAnchor.constraint(equalToConstant: 120),
            
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.topAnchor.constraint(equalTo: imageProfil.bottomAnchor, constant: 70),
            
            occuptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            occuptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            occuptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: occuptionTextField.bottomAnchor, constant: 10),
            
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            
            singUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            singUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            singUpButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            singUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            singUpButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func didChangedImage() {
        let pickImage = UIImagePickerController()
        pickImage.allowsEditing = true
        pickImage.delegate = self
        present(pickImage, animated: true)
    }
    
    @objc private func goToMainPage() {
        let current = CurrentUser(name: registerViewModel.name,
                                  occuption: registerViewModel.occupation,
                                  password: registerViewModel.password,
                                  email: registerViewModel.email,
                                  profileImage: imageData)
        
        RegisterServiceImp()
            .register(with: current)
            .sink { resp in
                switch resp {
                case .failure(let error):
                    self.alertMessage(error.localizedDescription)
                default: break
                }
            } receiveValue: { _ in
                //
            }
            .store(in: &cancelled)
    }
    
    @objc func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            let logInButtonPositionY = self.singUpButton.frame.origin.y + self.singUpButton.frame.height + self.view.safeAreaInsets.top
            let keyboardOriginY = self.view.frame.height - keyboardHeight

            let yOffet = keyboardOriginY < logInButtonPositionY ? logInButtonPositionY - keyboardOriginY + 15 : 0

            self.scrollView.contentOffset = CGPoint(x: 0, y: yOffet)
        }
    }

    @objc func didHidekeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }

    @objc func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)

    }
    
    @objc private func closedRegister() {
        dismiss(animated: true)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageProfil.image = image
            
            if let cropImage = image.pngData() {
                self.imageData = cropImage
            }
        }
        
        dismiss(animated: true)
    }
}
