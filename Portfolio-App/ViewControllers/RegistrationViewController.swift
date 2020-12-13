//
//  ViewController.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 11.12.2020.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: IB Outlets
    @IBOutlet var progressView: UIProgressView!
    
    @IBOutlet var firstStackView: UIStackView!
    @IBOutlet var secondStackView: UIStackView! {
        didSet {
            secondStackView.isHidden = true
        }
    }
    @IBOutlet var thirdStackView: UIStackView! {
        didSet {
            thirdStackView.isHidden = true
        }
    }
    
    @IBOutlet var infoImageViews: [UIImageView]! {
        didSet {
            infoImageViews.forEach {
                $0.layer.cornerRadius = 12
            }
        }
    }
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            textFields.forEach {
                let placeholderText = $0.placeholder != nil ? $0.placeholder! : ""
                $0.attributedPlaceholder = NSAttributedString(
                    string: placeholderText,
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.additionalTextColor
                    ])
            }
        }
    }
    
    @IBOutlet var mainButton: UIButton! {
        didSet {
            mainButton.layer.cornerRadius = 12
            mainButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet var fioTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var mailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var pinTextField: UITextField!
    
    @IBOutlet var titleStateLabel: UILabel!

    // MARK: Public properties
    var model = RegistrationModel()
    var userFio = ""
    var userAge = ""
    var userMail = ""
    var userPhone = ""
    var userPin = ""
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewFromModelState), name: Notification.Name("changeView"), object: nil)
        
        textFields.forEach {
            $0.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: IB Actions
    @IBAction func didTappedMainButton(_ sender: UIButton) {
        switch model.state {
        case .initialState:
            guard let fio = fioTextField.text, !fio.isEmpty else {
                showAlertAboutEmptyTextFields()
                return
            }
            guard let age = ageTextField.text, !age.isEmpty else {
                showAlertAboutEmptyTextFields()
                return
            }
            userFio = fio
            userAge = age
            model.nextState()
        case .phoneAndMailState:
            guard let mail = mailTextField.text, !mail.isEmpty else {
                showAlertAboutEmptyTextFields()
                return
            }
            guard let phone = phoneTextField.text, !phone.isEmpty else {
                showAlertAboutEmptyTextFields()
                return
            }
            userMail = mail
            userPhone = phone
            model.nextState()
        case .finalState:
            guard let pin = pinTextField.text, !pin.isEmpty, pin.count == 4 else {
                showAlertAboutEmptyTextFields()
                return
            }
            userPin = pin
            saveUser()
            performSegue(withIdentifier: "goToMainTabBar", sender: self)
        }
        
    }
    
    // MARK: Private Methods
    @objc private func updateViewFromModelState() {
        switch model.state {
        case .initialState:
            progressView.setProgress(0.33, animated: true)
            titleStateLabel.text = "Давай приступим"
            secondStackView.isHidden = true
            thirdStackView.isHidden = true
            firstStackView.isHidden = false
            return
        case .phoneAndMailState:
            progressView.setProgress(0.66, animated: true)
            titleStateLabel.text = "Еще немного..."
            firstStackView.isHidden = true
            thirdStackView.isHidden = true
            secondStackView.isHidden = false
            return
        case .finalState:
            progressView.setProgress(0.99, animated: true)
            titleStateLabel.text = "Последний шаг!"
            mainButton.setTitle("Готово", for: .normal)
            firstStackView.isHidden = true
            secondStackView.isHidden = true
            thirdStackView.isHidden = false
            return
        }
    }
    
    private func saveUser() {
        let user = UserModel(name: userFio, age: Int(userAge)!, mail: userMail, phone: userPhone)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "savedUser")
            defaults.setValue(userPin, forKey: "savedPin")
            UserDefaults.haveActiveProfile = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("changeView"), object: nil)
    }

}

// MARK: UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.fioTextField:
            let allowedCharacters = CharacterSet.letters
            let space = CharacterSet.whitespaces
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) || space.isSuperset(of: characterSet)
        case self.ageTextField:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        case self.pinTextField:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            if let text = self.pinTextField.text {
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        return true
                    }
                }
                return allowedCharacters.isSuperset(of: characterSet) && text.count < 4
            }
            return allowedCharacters.isSuperset(of: characterSet)
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.fioTextField:
            self.ageTextField.becomeFirstResponder()
        case self.ageTextField:
            self.view.endEditing(true)
        case self.mailTextField:
            self.phoneTextField.becomeFirstResponder()
        case self.phoneTextField:
            self.view.endEditing(true)
        case self.pinTextField:
            self.view.endEditing(true)
        default:
            self.view.endEditing(true)
        }
    }
}

// MARK: Alerts
extension RegistrationViewController {
    private func showAlertAboutEmptyTextFields() {
        let message = "Пожалуйста, заполните все поля"
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

