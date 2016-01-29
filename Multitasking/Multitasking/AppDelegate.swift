//
//  AppDelegate.swift
//  Multitasking
//
//  Created by qihaijun on 1/29/16.
//  Copyright © 2016 VictorChee. All rights reserved.
//
//  https://www.objc.io/issues/5-ios7/multitasking/
//  http://www.cocoachina.com/industry/20131114/7350.html

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        return true
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration)
        guard let url = NSURL(string: "https://victorchee.github.io/test/test.json") else {
            completionHandler(UIBackgroundFetchResult.Failed)
            return
        }
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            if let _ = error {
                completionHandler(.Failed)
                return
            }
            
            if let data = data {
                let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                print(string)
                completionHandler(.NewData)
            } else {
                completionHandler(.NoData)
            }
        }
        task.resume()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        // start background fetch here
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    var backgroundSessionCompletionHandler: (() -> Void)?
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
}

