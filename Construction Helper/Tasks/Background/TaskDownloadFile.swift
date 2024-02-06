//
//  TaskDownloadFile.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation
import Signals
import BackgroundTasks

class TaskDownloadFile: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    static let shared = TaskDownloadFile()
    var backgroundSessionCompletionHandler: (() -> Void)?
    
    private override init() {}
    
    private let onDownloadComplete = Signal<String>()
    private let onDownloadProgress = Signal<Double>()
    
    func addToBackgroundDownload(with projectId: Int, and url: URL) -> Signal<String> {
        
        let config = URLSessionConfiguration.background(withIdentifier: BGTaskScheduler.BACKGROUND_TASK_DENTIFIER + String(projectId))
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
        
        return onDownloadComplete
    }
    
    func getProgress() -> Signal<Double> {
        return onDownloadProgress
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(downloadTask.originalRequest!.url!.lastPathComponent)

        do {
            
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }

            try FileManager.default.moveItem(at: location, to: destinationURL)

            onDownloadComplete.fire(destinationURL.absoluteString)
            
        } catch let error {
            print("Could not move file to destination: \(error)")
            onDownloadComplete.fire("")
        }

    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Error download \(String(describing: error?.localizedDescription))")
        DispatchQueue.main.async { [self] in
            if let completionHandler = self.backgroundSessionCompletionHandler {
                self.backgroundSessionCompletionHandler = nil
                onDownloadComplete.fire("Error download \(session.description)")
                completionHandler()
                return
            }
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("Error download \(error?.localizedDescription ?? "Nilll")")
        DispatchQueue.main.async { [self] in
            if let completionHandler = self.backgroundSessionCompletionHandler {
                self.backgroundSessionCompletionHandler = nil
                onDownloadComplete.fire("Error download \(session.description)")
                completionHandler()
                return
            }
        }
    }

    @available(iOS 7.0, *)
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async { [self] in
            if let completionHandler = self.backgroundSessionCompletionHandler {
                self.backgroundSessionCompletionHandler = nil
                onDownloadComplete.fire("Error download \(session.description)")
                completionHandler()
                return
            }
        }
        
    }
    
}

extension TaskDownloadFile {
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData _: Int64, totalBytesWritten _: Int64, totalBytesExpectedToWrite _: Int64) {
        onDownloadProgress.fire(downloadTask.progress.fractionCompleted)
        print("Progress %f for %@, \(downloadTask.progress.fractionCompleted), of \(downloadTask.progress.totalUnitCount)")
    }
}
