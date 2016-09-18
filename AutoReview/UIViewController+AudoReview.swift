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

        guard let appVersion = Bundle.autoreview_appVersion else {
            return
        }

        let noNeedReviewOnTheAppStoreKey = "nixzhu_AutoReview_\(appVersion)_noNeedReviewOnTheAppStoreKey"
        let exponentialBackoffKey = "nixzhu_AutoReview_\(appVersion)_exponentialBackoffKey"
        let tryReviewOnTheAppStoreCountKey = "nixzhu_AutoReview_\(appVersion)_tryReviewOnTheAppStoreCountKey"

        let userDefaults = UserDefaults.standard

        func noNeedReviewOnTheAppStore() -> Bool {
            return userDefaults.bool(forKey: noNeedReviewOnTheAppStoreKey)
        }

        func setNoNeedReviewOnTheAppStore() {
            return userDefaults.set(true, forKey: noNeedReviewOnTheAppStoreKey)
        }

        func exponentialBackoff() -> Int {
            return (userDefaults.object(forKey: exponentialBackoffKey) as? Int) ?? info.initialExponentialBackoff
        }

        func increaseExponentialBackoff() {
            let newValue = exponentialBackoff() + 1
            userDefaults.set(newValue, forKey: exponentialBackoffKey)
        }

        func tryReviewOnTheAppStoreCount() -> Int {
            return userDefaults.integer(forKey: tryReviewOnTheAppStoreCountKey)
        }

        func increaseTryReviewOnTheAppStoreCount() {
            let newValue = tryReviewOnTheAppStoreCount() + 1
            userDefaults.set(newValue, forKey: tryReviewOnTheAppStoreCountKey)
        }

        DispatchQueue.main.async { [weak self] in

            guard !noNeedReviewOnTheAppStore() else {
                return
            }

            defer {
                increaseTryReviewOnTheAppStoreCount()
            }

            let currentExponentialBackoff = exponentialBackoff()
            let currentTryReviewOnTheAppStoreCount = tryReviewOnTheAppStoreCount()

            guard Double(currentTryReviewOnTheAppStoreCount) > pow(Double(info.exponentialFunctionBase), Double(currentExponentialBackoff)) else {
                return
            }

            let alertController = UIAlertController(title: info.title, message: info.message, preferredStyle: .alert)

            do {
                let action: UIAlertAction = UIAlertAction(title: info.doNotRemindMeInThisVersionTitle, style: .default) { action in
                    setNoNeedReviewOnTheAppStore()
                }
                alertController.addAction(action)
            }

            do {
                let action: UIAlertAction = UIAlertAction(title: info.maybeNextTimeTitle, style: .default) { action in
                    increaseExponentialBackoff()
                }
                alertController.addAction(action)
            }

            do {
                let action: UIAlertAction = UIAlertAction(title: info.confirmTitle, style: .cancel) { action in
                    setNoNeedReviewOnTheAppStore()
                    UIApplication.shared.autoreview_openAppStore(forAppWithAppID: info.appID)
                }
                alertController.addAction(action)
            }
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}

