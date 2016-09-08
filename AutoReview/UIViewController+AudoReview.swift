//
//  UIViewController+Review.swift
//  AutoReview
//
//  Created by NIX on 16/7/28.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import UIKit

extension UIViewController {

    public func autoreview_tryReviewApp(withInfo info: Info) {

        guard let appVersion = NSBundle.autoreview_appVersion else {
            return
        }

        let noNeedReviewOnTheAppStoreKey = "nixzhu_AutoReview_\(appVersion)_noNeedReviewOnTheAppStoreKey"
        let exponentialBackoffKey = "nixzhu_AutoReview_\(appVersion)_exponentialBackoffKey"
        let tryReviewOnTheAppStoreCountKey = "nixzhu_AutoReview_\(appVersion)_tryReviewOnTheAppStoreCountKey"

        //let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDefaults = NSUserDefaults(suiteName: "")!

        func noNeedReviewOnTheAppStore() -> Bool {
            return userDefaults.boolForKey(noNeedReviewOnTheAppStoreKey)
        }

        func setNoNeedReviewOnTheAppStore() {
            return userDefaults.setBool(true, forKey: noNeedReviewOnTheAppStoreKey)
        }

        func exponentialBackoff() -> Int {
            return (userDefaults.objectForKey(exponentialBackoffKey) as? Int) ?? info.initialExponentialBackoff
        }

        func increaseExponentialBackoff() {
            let newValue = exponentialBackoff() + 1
            userDefaults.setInteger(newValue, forKey: exponentialBackoffKey)
        }

        func tryReviewOnTheAppStoreCount() -> Int {
            return userDefaults.integerForKey(tryReviewOnTheAppStoreCountKey)
        }

        func increaseTryReviewOnTheAppStoreCount() {
            let newValue = tryReviewOnTheAppStoreCount() + 1
            userDefaults.setInteger(newValue, forKey: tryReviewOnTheAppStoreCountKey)
        }

        dispatch_async(dispatch_get_main_queue()) { [weak self] in

            guard !noNeedReviewOnTheAppStore() else {
                return
            }

            defer {
                increaseTryReviewOnTheAppStoreCount()
            }

            let exponentialBackoff = exponentialBackoff()
            let tryReviewOnTheAppStoreCount = tryReviewOnTheAppStoreCount()

            guard Double(tryReviewOnTheAppStoreCount) > pow(Double(info.exponentialFunctionBase), Double(exponentialBackoff)) else {
                return
            }

            let alertController = UIAlertController(title: info.title, message: info.message, preferredStyle: .Alert)

            do {
                let action: UIAlertAction = UIAlertAction(title: info.doNotRemindMeInThisVersionTitle, style: .Default) { action in
                    setNoNeedReviewOnTheAppStore()
                }
                alertController.addAction(action)
            }

            do {
                let action: UIAlertAction = UIAlertAction(title: info.maybeNextTimeTitle, style: .Default) { action in
                    increaseExponentialBackoff()
                }
                alertController.addAction(action)
            }

            do {
                let action: UIAlertAction = UIAlertAction(title: info.confirmTitle, style: .Cancel) { action in
                    setNoNeedReviewOnTheAppStore()
                    UIApplication.sharedApplication().autoreview_openAppStore(forAppWithAppID: info.appID)
                }
                alertController.addAction(action)
            }
            
            self?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

