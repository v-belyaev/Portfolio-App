//
//  HomeViewController.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 13.12.2020.
//

import UIKit
import PDFKit

class HomeViewController: UIViewController {
    
    // MARK: IB Outlets
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var pdfCreateButton: UIButton! {
        didSet {
            pdfCreateButton.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet var textViews: [UITextView]! {
        didSet {
            textViews.forEach {
                $0.layer.cornerRadius = 12
            }
        }
    }
    
    @IBOutlet var skillsTextView: UITextView!
    @IBOutlet var workTextView: UITextView!
    
    // MARK: Public Properties
    var user = UserModel(name: "", age: 0, mail: "", phone: "")
    
    // MARK: ViewController Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        if let savedUser = defaults.object(forKey: "savedUser") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(UserModel.self, from: savedUser) {
                user = loadedUser
                titleLabel.text = "Добро пожаловать \(user.name)"
            }
        }
    }
    
    // MARK: IB Actions
    @IBAction func didPDFButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "pdfPreview", sender: self)
    }
    
    // MARK: Public Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pdfPreview" {
            guard let vc = segue.destination as? UINavigationController else { return }
            guard let destinationVC = vc.viewControllers.first as? PDFPreviewViewController else { return }
            let pdfCreator = PDFCreator(user: user, skills: skillsTextView.text ?? "", workingExperience: workTextView.text ?? "")
            destinationVC.documentData = pdfCreator.createPDF()
        }
    }

}
