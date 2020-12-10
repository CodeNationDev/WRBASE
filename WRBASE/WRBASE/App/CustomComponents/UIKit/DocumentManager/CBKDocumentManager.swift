//
import Foundation
import UIKit

public protocol CBKDocumentManagerDelegate: class {
    func didfinishDownloadWithError(_ response: String)
    func didFinishDownloadSuccess(_ url: URL)
}

public class CBKDocumentManager: NSObject {

    public static var shared = CBKDocumentManager()
    var docViewer: UIDocumentInteractionController?
    var url: URL?
    var downloadTask: URLSessionDownloadTask?
    public var documentViewerDelegate: CBKDocumentManagerDelegate?
    var name: String?
}


// MARK: Extensions

extension CBKDocumentManager: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        var urlLocation = location
        var aux:String = String(urlLocation.deletingPathExtension().absoluteString[..<urlLocation.deletingPathExtension().absoluteString.lastIndex(of: "/")!])
        aux = "\(aux)/\((downloadTask.response?.suggestedFilename) ?? "File".appending(url!.pathExtension))"
        let newLocation = URL(string: aux)!
        let manager = FileManager.default
        
        do {
            if FileManager.default.fileExists(atPath: newLocation.path) {
               try FileManager.default.removeItem(atPath: newLocation.path)
            }
            try manager.moveItem(at: urlLocation, to: newLocation)
        } catch let error {
            LoggerManager.shared.log(message: "[DOWNLOAD ERROR] Downloading document: \(error.localizedDescription)")
            documentViewerDelegate?.didfinishDownloadWithError(error.localizedDescription)
        }
        urlLocation = urlLocation.deletingPathExtension()
        documentViewerDelegate?.didFinishDownloadSuccess(newLocation)
        if let name = name {
            docViewer?.name = name
        }
        DispatchQueue.main.async {
            downloadTask.cancel()
            LoggerManager.shared.log(message: "[DOWNLOAD] Document download succeed.")
            self.docViewer?.presentPreview(animated: true)
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            DispatchQueue.main.async {
                LoggerManager.shared.log(message: "[DOWNLOAD ERROR] Downloading document: \(error!.localizedDescription)")
                self.documentViewerDelegate?.didfinishDownloadWithError(error!.localizedDescription)
            }
        }
    }

    public func startDownload(url: URL?, name: String? = nil) {
        if let url = url {
            self.url = url
            if let name = name {
                self.name = name
            }
                let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
                LoggerManager.shared.log(message: "[DOWNLOAD] Download start: \(url)")
                downloadTask = urlSession.downloadTask(with: url)
                downloadTask?.resume()
            }
        }
}

