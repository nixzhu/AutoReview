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

        func noNeedReviewOnTheAppStore() -> Bool {
            return NSUserDefaults.standardUserDefaults().boolForKey(noNeedReviewOnTheAppStoreKey)
        }

        func setNoNeedReviewOnTheAppStore() {
            return NSUserDefaults.standardUserDefaults().setBool(true, forKey: noNeedReviewOnTheAppStoreKey)
        }

        func exponentialBackoff() -> Int {
            return (NSUserDefaults.standardUserDefaults().objectForKey(exponentialBackoffKey) as? Int) ?? info.initialExponentialBackoff
        }

        func increaseExponentialBackoff() {
            let newValue = exponentialBackoff() + 1
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: exponentialBackoffKey)
        }

        func tryReviewOnTheAppStoreCount() -> Int {
            return NSUserDefaults.standardUserDefaults().integerForKey(tryReviewOnTheAppStoreCountKey)
        }

        func increaseTryReviewOnTheAppStoreCount() {
            let newValue = tryReviewOnTheAppStoreCount() + 1
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: tryReviewOnTheAppStoreCountKey)
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

