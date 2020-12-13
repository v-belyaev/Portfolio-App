//
//  PDFCreator.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 13.12.2020.
//

import UIKit

class PDFCreator: NSObject {
    
    let user: UserModel
    let skills: String
    let workingExperience: String
    
    init(user: UserModel, skills: String, workingExperience: String) {
        self.user = user
        self.skills = skills
        self.workingExperience = workingExperience
    }
    
    func createPDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: user.name,
            kCGPDFContextAuthor: user.mail
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { (context) in
            context.beginPage()

            let titleAttributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)
            ]
            let title = "Портфолио\n\(user.name)"
            title.draw(at: CGPoint(x: 20, y: 0), withAttributes: titleAttributes)
        
            let labelAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .medium)
            ]
        
            let infoAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ]
        
            let infoLabel = "Возраст: \(user.age);\nПочта: \(user.mail);\nТелефон: \(user.phone)"
        
            infoLabel.draw(at: CGPoint(x: 20, y: 100), withAttributes: infoAttributes)
        
            let skillsLabel = "Навыки:\n\(skills)"
            skillsLabel.draw(at: CGPoint(x: 20, y: 200), withAttributes: labelAttributes)
        
            let workingLabel = "Опыт работы:\n\(workingExperience)"
            workingLabel.draw(at: CGPoint(x: 20, y: 500), withAttributes: labelAttributes)
        }

        return data
    }
}
