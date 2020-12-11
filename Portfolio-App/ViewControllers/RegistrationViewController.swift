//
//  ViewController.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 11.12.2020.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: IB Outlets
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

