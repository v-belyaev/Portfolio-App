//
//  LoginViewController.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 12.12.2020.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    // MARK: IB Outlets
    @IBOutlet var pinViews: [UIView]! {
        didSet {
            pinViews.forEach {
                $0.layer.cornerRadius = $0.layer.bounds.height / 2
                $0.clipsToBounds = true
                $0.layer.borderWidth = 4
                $0.layer.borderColor = UIColor.activeGreen.cgColor
            }
        }
    }
    
    // MARK: Private Properties
    private var currentPinIndex = 0
    private var pinString = ""
    
    // MARK: IB Actions
    @IBAction func didTappedPinButton(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        guard sender.tag != 10 else {
            removeLastPinNumber()
            return
        }
        
        guard sender.tag != 11 else {
            biometricCheck()
            return
        }
        
        pinString += String(sender.tag)
        print(pinString)
        pinViews[currentPinIndex].backgroundColor = UIColor.activeYellow
        currentPinIndex += 1
        
        if pinString.count == 4 {
            startCheckingPin()
        }
    }
    
    // MARK: Private Methods
    private func checkPin() -> Bool {
        if let pinCode = UserDefaults.standard.string(forKey: "pin_code") {
            guard pinString == pinCode else { return false }
            return true
        }
        
        return false
    }
    
    private func showErrorAlert() {
        let message = "Неверный пин! Пожалуйста, повторите попытку"
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setInitialUI() {
        pinViews.forEach {
            $0.backgroundColor = UIColor.clear
        }
        pinString = ""
        currentPinIndex = 0
    }
    
    private func removeLastPinNumber() {
        guard pinString.count != 0 else { return }
        guard currentPinIndex != 0 else { return }
        
        pinString.removeLast()
        currentPinIndex -= 1
        pinViews[currentPinIndex].backgroundColor = UIColor.clear
    }
    
    private func startCheckingPin() {
        let success = checkPin()
        if success {
            // TODO: Perform Segue
        } else {
            showErrorAlert()
            setInitialUI()
        }
    }
    
    private func biometricCheck() {
        let context = LAContext()
                
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Разблокируйте ваше портфолио") { [weak self] (success, _) in
                if success {
                    DispatchQueue.main.async {
                        self?.setInitialUI()
                        // TODO: Perform Segue
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.setInitialUI()
                    }
                }
            }
        }
    }
}
