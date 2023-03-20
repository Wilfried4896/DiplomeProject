
import UIKit
import Combine

class LoginController: UIViewController {
    weak var coordinator: AuthCoordinator?
    
    let scrollView = UIScrollView()
    let loginVm = LoginViewModel()
    var cancelled = Set<AnyCancellable>()
    
    lazy var emailTextField: UITextField = {
        let email = UITextField()
        email.customField(_keyboardType: .emailAddress, _placeholder: "Email")
        return email
    }()
    
    lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.customField(_keyboardType: nil, _placeholder: "Password")
        password.isSecureTextEntry = true
        return password
    }()
    
    lazy var singInButton: UIButton = {
        let signIn = UIButton(type: .system)
        signIn.setTitle("Sign In", for: .normal)
        signIn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        signIn.tintColor = .white
        signIn.backgroundColor = .systemOrange
        signIn.layer.cornerRadius = 10
        signIn.addTarget(self, action: #selector(goToMainPage), for: .touchUpInside)
        signIn.translatesAutoresizingMaskIntoConstraints = false
        return signIn
    }()
    
    lazy var createAccountButton: UIButton = {
        let createAccount = UIButton(type: .system)
        createAccount.setTitle("Create Account ?", for: .normal)
        createAccount.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        createAccount.addTarget(self, action: #selector(goToCreateAccount), for: .touchUpInside)
        createAccount.translatesAutoresizingMaskIntoConstraints = false
        return createAccount
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurationLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didHidekeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    private func configurationLogin() {
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Login"
        
        let tapKeyboard = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapKeyboard)
                
        view.addSubview(scrollView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(createAccountButton)
        scrollView.addSubview(singInButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutContraints()
        setupPublishers()
    }
    
    private func layoutContraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 150),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createAccountButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            
            singInButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 20),
            singInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            singInButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            singInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            singInButton.heightAnchor.constraint(equalToConstant: 50),
         ])
    }
    
    func setupPublishers() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.emailPush, on: loginVm)
            .store(in: &cancelled)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.passwordPush, on: loginVm)
            .store(in: &cancelled)
        
        loginVm.isSubmit
            .assign(to: \.isEnabled, on: singInButton)
            .store(in: &cancelled)
        
        loginVm.$state
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.singInButton.isEnabled = false
                case .success:
                    self?.singInButton.isEnabled = true
                    self?.coordinator?.parent?.mainPage()
                case .failed(let error):
                    self?.alertMessage(error.localizedDescription)
                case .none:
                    break
                }
            }
            .store(in: &cancelled)
    }
    
    
    @objc func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            let logInButtonPositionY = self.singInButton.frame.origin.y + self.singInButton.frame.height + self.view.safeAreaInsets.top
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
    
    @objc private func goToMainPage() {
        loginVm.loginIn()
    }
    
    @objc private func goToCreateAccount() {
        coordinator?.registrationPage()
    }
}
