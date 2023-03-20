
import UIKit

class PersonalInformationUpdateController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    
    private var account: User?
    
    lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.customField(_keyboardType: .namePhonePad, _placeholder: "Name")
        return name
    }()
    
    lazy var brithDayTextField: UITextField = {
        let brithDay = UITextField()
        brithDay.customField(_keyboardType: nil, _placeholder: "brithDay")
        return brithDay
    }()
    
    lazy var cityTextField: UITextField = {
        let city = UITextField()
        city.customField(_keyboardType: .namePhonePad, _placeholder: "City")
        return city
    }()
    
    lazy var occuptionTextField: UITextField = {
        let occuption = UITextField()
        occuption.customField(_keyboardType: .namePhonePad, _placeholder: "Occuption")
        return occuption
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
    }
    
    private func configuration() {
        view.backgroundColor = .systemBackground
        
        let righButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UpdateInfornationUser))
        righButton.tintColor = .systemOrange
        
        navigationItem.rightBarButtonItem = righButton
        
        view.addSubview(nameTextField)
        view.addSubview(brithDayTextField)
        view.addSubview(cityTextField)
        view.addSubview(occuptionTextField)
        
        brithDayTextField.datePicker(target: self,
                                     doneAction: #selector(doneAction),
                                     cancelAction: #selector(cancelAction),
                                     datePickerMode: .date)
        layoutContraintes()
        setConfiguration()
    }
    
    private func layoutContraintes() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            brithDayTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            brithDayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            brithDayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            cityTextField.topAnchor.constraint(equalTo: brithDayTextField.bottomAnchor, constant: 30),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            occuptionTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 30),
            occuptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            occuptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
        ])
    }
    
    private func setConfiguration() {
        guard let uid = UserDefaults.standard.string(forKey: "StateDidChangeListener") else { return }
        account = CoreDataManager.shared.fectchAccountUser(uid)
        
        if let account  {
            nameTextField.text = account.name
            occuptionTextField.text = account.occuption
            cityTextField.text = account.city
            brithDayTextField.text = account.birthDay
        }
    }
    
    @objc private func doneAction() {
        if let datePicker = brithDayTextField.inputView as? UIDatePicker {
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormate.string(from: datePicker.date)
            self.brithDayTextField.text = dateString
            
            self.brithDayTextField.resignFirstResponder()
        }
    }
    
    @objc private func cancelAction() {
        self.brithDayTextField.resignFirstResponder()
    }
    
    @objc private func UpdateInfornationUser() {
        if let account {
            account.name = nameTextField.text
            account.occuption = occuptionTextField.text
            account.city = cityTextField.text
            account.birthDay = brithDayTextField.text
            
            CoreDataManager.shared.currentDataUpdate(_current: account)
            
        }
        dismiss(animated: true)
    }
}


