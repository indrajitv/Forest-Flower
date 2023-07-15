//
//  Downloader.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 15/06/23.
//

import SwiftUI

class Downloader: NSObject {

    let url: URL

    let downloadSession: URLSession

    private var continuation: AsyncStream<Event>.Continuation?

    private lazy var task: URLSessionDownloadTask = {
        let task = self.downloadSession.downloadTask(with: url)
        task.delegate = self
        return task
    }()

    var events: AsyncStream<Event> {
        return AsyncStream { continuation in
            self.continuation = continuation
            task.resume()
            continuation.onTermination = { @Sendable [weak self] _ in
                self?.task.cancel()
            }
        }
    }

    var isDownloading: Bool {
        task.state == .running
    }

    init(url: URL, downloadSession: URLSession) {
        self.url = url
        self.downloadSession = downloadSession
    }

    func pause() {
        task.suspend()
    }

    func resume() {
        task.resume()
    }

    func cancel() {
        task.cancel()
    }
}

extension Downloader {
    enum Event {
        case progress(currentBytes: Int64, totalBytes: Int64)
        case success(data: Data)
        case failed(error: Error)
    }
}

extension Downloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        continuation?.yield(.progress(currentBytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite))
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data.init(contentsOf: location)
            //TODO: Passing data is not a good idea, Pass permanent location to reduce main memory usage.
            continuation?.yield(.success(data: data))
        } catch {
            assertionFailure("\(error)")
        }
        continuation?.finish()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        if let error = error {
            continuation?.yield(.failed(error: error))
        }
    }
}
