//
//  ViewController.swift
//  Multitasking
//
//  Created by qihaijun on 1/29/16.
//  Copyright © 2016 VictorChee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate {
    
    var task: NSURLSessionDownloadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.victorchee.backgroundTransfer")
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        guard let url = NSURL(string: "https://victorchee.github.io/test/test.json") else {
            return
        }
        task = session.downloadTaskWithURL(url)
        task?.resume()
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let task = self.task where task.isEqual(downloadTask) {
            let progress = totalBytesWritten / totalBytesExpectedToWrite
            print("download task progress \(progress)")
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("download task finished")
        
        let fileManager = NSFileManager.defaultManager()
        let URLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        guard let documentDirectory = URLs.first else {
            return
        }
        
        let originalURL = downloadTask.originalRequest?.URL
        let destinationURL = documentDirectory.URLByAppendingPathComponent(originalURL?.lastPathComponent ?? "temp")
        
        do {
            try fileManager.copyItemAtURL(location, toURL: destinationURL)
            print("move file success")
        } catch {
            print("move file failed")
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let task = self.task where task.isEqual(task) {
            let progress = task.countOfBytesReceived / task.countOfBytesExpectedToReceive
            print("download task complete \(progress)")
            self.task = nil
        }
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        guard let handler = appDelegate?.backgroundSessionCompletionHandler else {
            return
        }
        appDelegate?.backgroundSessionCompletionHandler = nil
        handler()
        print("All tasks are finished")
    }
}

