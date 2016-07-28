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

        let remindAction: dispatch_block_t = { [weak self] in

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

        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), remindAction)
    }
}
