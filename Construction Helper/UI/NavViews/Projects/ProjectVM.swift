//
//  ProjectVM.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation
import Signals

class ProjectVM: NSObject, UIScrollViewDelegate {
    
    private var model = ProjectsModelItemView()
    private let initialHeight = 216.67
    private var previousScrollPos: CGFloat = 0
    var displayLink: CADisplayLink?
    private let projectRepository = ProjectsRepository()
    var pdfButtonText =  "See PDF"
    
    let onPDFButtonTextChange = Signal<String?>()
    let onPDFDownloaded = Signal<String>()
    let onScrolled = Signal<CGFloat>()
    
    init(model: ProjectsModelItemView) {

        self.model = model
    }
    
    deinit {
        //MARK: Clear all observers
        TaskDownloadFile.shared.getProgress().cancelSubscription(for: self)
    }
    
    func maybeDownloadPDF() {
        startObservingForAnim()
        if !model.isAlreadyDownloaded() {
            setupDownloadOberservers()
        } else {
            if let filePath = model.fileURL, Helper.fileExists(atPath: filePath) {
                navigateToPDFView(path: filePath)
            } else {
                setupProjectUpdateObservers()
            }
        }
    }
    
    private func startObservingForAnim() {
        stopObservingForAnim()

        displayLink = CADisplayLink(target: self, selector: #selector(updateFunction))
        displayLink?.add(to: .main, forMode: .commonModes)
    }
    
    @objc private func updateFunction() {
        
        updateTextFromOtherThread()
    }
    
    private func stopObservingForAnim() {
        displayLink?.invalidate()
        displayLink = nil
        updateTextFromOtherThread()
    }
    
    private func updateTextFromOtherThread() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.onPDFButtonTextChange.fire(weakSelf.pdfButtonText)
        }
    }
    
    private func setupProjectUpdateObservers() {
        
        modifyPDFButtonText(textOnly: "Fetching from server")
        
        projectRepository.onProjectUpdated.subscribeOnce(with: self) { [weak self] updatedProject in
            guard let weakSelf = self else {return}
            weakSelf.model = updatedProject
            weakSelf.modifyPDFButtonText(textOnly: "Fetch Completed! Download PDF")
            weakSelf.stopObservingForAnim()
            weakSelf.maybeDownloadPDF()
        }
        
        projectRepository.requestProjectUpdate(with: model.id)
    }
    
    private func setupDownloadOberservers() {
        startObservingForAnim()
        guard
            let pdfLink = model.fileURL,
            let url = URL(string: pdfLink)
        else {return}
        modifyPDFButtonText(textOnly: "Starting Download")
        let backgroundDownload = TaskDownloadFile.shared
        let downloadObserver = backgroundDownload.addToBackgroundDownload(with: model.id, and: url)
        downloadObserver.subscribeOnce(with: self) { [weak self] path in
            guard let weakSelf = self else {return}
            weakSelf.onPDFDownloaded.fire(path)
            weakSelf.model.fileURL = path
            weakSelf.changeFilePath(path: path)
            weakSelf.pdfButtonText = "Downloaded! Click to see"
            weakSelf.navigateToPDFView(path: path)
            weakSelf.stopObservingForAnim()
        }
        
        backgroundDownload.getProgress().subscribe(with: self) { [weak self] progress in
            guard let weakSelf = self else {return}
            
            weakSelf.modifyPDFButtonText(progress: progress)
            
        }
        
    }
    
    func modifyPDFButtonText(progress: Double? = nil, textOnly: String? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            if let textOnly = textOnly {
                weakSelf.pdfButtonText = textOnly
                return
            } else if let progress = progress {
                let percentage = String(format: "%.2f%", (progress * 100))
                var buttonText = "Downloaded...\(percentage) %"
                if progress >= 1 {
                    buttonText = buttonText + " Please wait!"
                }
                weakSelf.pdfButtonText = buttonText
            }
        }
        
        
    }
    
    private func navigateToPDFView(path: String) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let _ = self else {return}
            let vc = ViewFactory.createView(screenName: .PDF_VIEW) as? PDFViewVC
            vc?.navigationItem.hidesBackButton = false
            vc?.pdfURL = path
            NotificationCenter.default.post(name: Notifications.ShowView, object: vc)
        }
        
    }
    
    private func changeFilePath(path: String) {
        projectRepository.requestProjectUpdate(with: model.id, path: path)
    }
}

extension ProjectVM {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y

        if yOffset < 0 {
            onScrolled.fire(initialHeight - yOffset)
        } else {
            let newHeight = max(0, initialHeight - yOffset)
            onScrolled.fire(newHeight)
        }
        
        scrollView.layoutIfNeeded()
        
        var offsetY = scrollView.contentOffset.y
        offsetY = offsetY < 0 ? 0 : offsetY

        if (self.previousScrollPos < offsetY) {
            NotificationCenter.default.post(name: Notifications.ViewScrolledDown, object: nil)
        }
        else if (self.previousScrollPos > offsetY) {
            NotificationCenter.default.post(name: Notifications.ViewScrolledUp, object: nil)
        }

        previousScrollPos = offsetY
    }
    
}
