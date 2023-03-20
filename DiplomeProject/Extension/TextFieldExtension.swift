
import UIKit

extension UITextField {
    
    func customField(_keyboardType: UIKeyboardType?, _placeholder: String) {
        borderStyle = UITextField.BorderStyle.roundedRect
        if let _keyboardType {
            keyboardType = _keyboardType
        }
        placeholder = _placeholder
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
       
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.datePickerMode = datePickerMode
                self.inputView = datePicker
                
                let toolBar = UIToolbar(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: screenWidth,
                                                      height: 44))
                toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                                  buttonItem(withSystemItemStyle: .flexibleSpace),
                                  buttonItem(withSystemItemStyle: .done)],
                                 animated: true)
                self.inputAccessoryView = toolBar
    }
}
