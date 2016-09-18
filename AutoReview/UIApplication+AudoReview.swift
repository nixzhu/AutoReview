//
//  UIApplication+Review.swift
//  AutoReview
//
//  Created by NIX on 16/7/28.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import UIKit

extension UIApplication {

    func autoreview_openAppStore(forAppWithAppID appID: String) {

        guard let appURL = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") else {
            return
        }

        if canOpenURL(appURL) {
            openURL(appURL)
        }
    }
}

