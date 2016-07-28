//
//  ReviewInfo.swift
//  AutoReview
//
//  Created by NIX on 16/7/28.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import Foundation

public struct Info {

    let appID: String
    let exponentialFunctionBase: Int
    let initialExponentialBackoff: Int
    let title: String
    let message: String
    let doNotRemindMeInThisVersionTitle: String
    let maybeNextTimeTitle: String
    let confirmTitle: String

    public init(appID: String, exponentialFunctionBase: Int = 2, initialExponentialBackoff: Int = 2, title: String, message: String, doNotRemindMeInThisVersionTitle: String, maybeNextTimeTitle: String, confirmTitle: String) {

        guard !appID.isEmpty else {
            fatalError("AutoReview: appID.isEmpty!")
        }

        guard exponentialFunctionBase >= 2 else {
            fatalError("AutoReview: Invalid exponentialFunctionBase!")
        }

        guard initialExponentialBackoff >= 0 else {
            fatalError("AutoReview: Invalid initialExponentialBackoff!")
        }

        self.appID = appID
        self.exponentialFunctionBase = exponentialFunctionBase
        self.initialExponentialBackoff = initialExponentialBackoff
        self.title = title
        self.message = message
        self.doNotRemindMeInThisVersionTitle = doNotRemindMeInThisVersionTitle
        self.maybeNextTimeTitle = maybeNextTimeTitle
        self.confirmTitle = confirmTitle
    }
}

