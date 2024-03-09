//
//  ProjectVC.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//
import Lottie
import UIKit

class ProjectVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadPDF: UIButton!
    @IBOutlet weak var downloadPDFLabel: UILabel!
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var projectDescriptionLabel: UILabel!
    @IBOutlet weak var projectLocationLabel: UILabel!
    @IBOutlet weak var projectSectorLabel: UILabel!
    @IBOutlet weak var projectProgressLabel: UILabel!

    private var viewModel: ProjectVM? = nil
    var project: ProjectsModelItemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ProjectVM(model: project)
        
        scrollView.delegate = self
        navigationItem.hidesBackButton = false
       
        setupObservers()
        operations()
        initialViews()
        
    }
    
    func initialViews() {
        downloadPDFLabel.text = project.isAlreadyDownloaded() ? "See PDF" : "Download PDF"
        projectTitleLabel.text = project.title
        projectLocationLabel.text = "Located at: " + project.location
        projectDescriptionLabel.text = "Starting from: " + project.duration
        projectSectorLabel.text = "Sector: " + project.sector
        projectProgressLabel.text = "In progress " + String(format: "%.2f%%", project.projectProgress)
    }
    
    private func setupObservers() {
        
        guard let viewModel = viewModel else {return}
        
        viewModel.onPDFButtonTextChange.subscribe(with: self) { [weak self] text in
            
            guard let weakSelf = self else {return}
            DispatchQueue.main.async { [weak weakSelf] in
                guard let weakerSelf = weakSelf else {return}
                weakerSelf.downloadPDFLabel.text = text
            }
        }
        
        viewModel.onScrolled.subscribe(with: self) { [weak self] newHeigh in
            
            guard let weakSelf = self else {return}
            weakSelf.imageViewHeightConstraint.constant = newHeigh
        }
        
        viewModel.onPDFDownloaded.subscribe(with: self) { [weak self]  path in
            
            guard let weakSelf = self else {return}
            weakSelf.project.fileURL = path
            
        }
        viewModel.modifyPDFButtonText()
    }
    
    private func operations() {
        downloadPDF.addTarget(self, action: #selector(onDownloadPDFClicked), for: .touchUpInside)
    }
    
    @objc func onDownloadPDFClicked() {
        
        guard let viewModel = viewModel else {return}
        
        viewModel.maybeDownloadPDF()
        
    }

}
