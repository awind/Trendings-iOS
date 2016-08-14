//
//  FabricEvent.swift
//  Trending
//
//  Created by Fei on 16/8/13.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import Fabric
import Crashlytics


class FabricEvent {
    
    static func logContentViewEvent(eventName: String, type: String, contentId: String) {
        Answers.logContentViewWithName(eventName, contentType: type, contentId: contentId, customAttributes: nil)
    }
    
    static func logContentViewEvent(eventName: String, type: String, contentId: String, attrs: [String:String]) {
        Answers.logContentViewWithName(eventName, contentType: type, contentId: contentId, customAttributes: attrs)
    }
    
    static func logCustomEvent(eventName: String) {
        Answers.logCustomEventWithName(eventName, customAttributes: nil)
    }
    
    static func logCustomEvent(eventName: String, attrs: [String:String]) {
        Answers.logCustomEventWithName(eventName, customAttributes: attrs)
    }
}
