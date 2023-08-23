//
//  AnalyticsService.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 23/08/23.
//

import Foundation
import FirebaseAnalytics

class AnalyticsService {
    
    static let instance = AnalyticsService()
    
    func likePostDoubleTap() {
        Analytics.logEvent("like_double_tap", parameters: nil)
    }
    
    func likePostHeartPressed() {
        Analytics.logEvent("like_heart_pressed", parameters: nil)
    }
}
