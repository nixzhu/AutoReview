//
//  UIViewController+AnyApp.swift
//  AnyApp
//
//  Created by NIX on 16/7/28.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import UIKit
import AutoReview

extension UIViewController {

    func remindUserToReview() {

        let remindAction: ()->() = { [weak self] in

            guard self?.view.window != nil else {
                return
            }

            let info = AutoReview.Info(
                appID: "983891256",
                title: NSLocalizedString("Review Yep", comment: ""),
                message: NSLocalizedString("Do you like Yep?\nWould you like to review it on the App Store?", comment: ""),
                doNotRemindMeInThisVersionTitle: NSLocalizedString("Do not remind me in this version", comment: ""),
                maybeNextTimeTitle: NSLocalizedString("Maybe next time", comment: ""),
                confirmTitle: NSLocalizedString("Review now", comment: "")
            )
            self?.autoreview_tryReviewApp(withInfo: info)
        }

        let time = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: remindAction)
    }
}
