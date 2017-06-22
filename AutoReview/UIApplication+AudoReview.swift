//
//  UIApplication+Review.swift
//  AutoReview
//
//  Created by NIX on 16/7/28.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import UIKit

extension UIApplication {

    public func autoreview_openAppStoreForApp(withAppID appID: String) {

        var appURL: URL?
        if #available(iOS 10.3, *) {
            appURL = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review")
        } else {
            appURL = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")
        }

        if let url = appURL, canOpenURL(url) {
            openURL(url)
        }
    }
}

