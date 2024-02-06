//
//  PDFViewVC.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 05/02/2024.
//

import UIKit
import PDFKit

class PDFViewVC: UIViewController {
    
    var pdfURL: String? = nil
    private var pdfView = PDFView()

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else {return}
            weakSelf.showPDF()
            weakSelf.view.layoutIfNeeded()
        }
    }
    
    func showPDF() {
        
        if let pdfURL = URL(string: pdfURL ?? "") {
            pdfView.translatesAutoresizingMaskIntoConstraints = false
             view.addSubview(pdfView)
             
             // Set constraints
             NSLayoutConstraint.activate([
                 pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                 pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                 pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                 pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
             ])
             
             // Enable auto scaling
            pdfView.autoScales = true
            pdfView.scaleFactor = 0.1
            pdfView.displayMode = .twoUpContinuous
            // Example to set custom zoom limits
            pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit * 0.5
            pdfView.maxScaleFactor = pdfView.scaleFactorForSizeToFit * 2.0

            pdfView.isUserInteractionEnabled = true

            // Load PDF
            if let document = PDFDocument(url: pdfURL) {
                pdfView.document = document
            }
        }
    }

}
