//
//  NSBundle+Review.swift
//  AutoReview
//
//  Created by NIX on 16/7/28.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation

extension NSBundle {

    static var autoreview_appVersion: String? {
        return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
    }
}

