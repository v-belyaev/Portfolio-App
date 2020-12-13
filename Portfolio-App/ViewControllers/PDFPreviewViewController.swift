//
//  PDFPreviewViewController.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 13.12.2020.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
    
    // MARK: IB Outlets
    @IBOutlet var shareBarButtonItem: UIBarButtonItem!
    
    // MARK: Public Properties
    var documentData: Data?
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add PDFView to view controller.
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        // Fit content in PDFView.
        pdfView.autoScales = true
        if let pdfData = documentData {
            pdfView.document = PDFDocument(data: pdfData)
        }
    }
    
    // MARK: IB Actions
    @IBAction func didShareButtonPressed(_ sender: UIBarButtonItem) {
        guard let document = documentData else { return }
        let activity = UIActivityViewController(activityItems: [document], applicationActivities: [])
        present(activity, animated: true, completion: nil)
    }
}
