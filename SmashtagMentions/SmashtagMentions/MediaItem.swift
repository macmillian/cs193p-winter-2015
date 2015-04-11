//
//  MediaItem.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//
//  Modified 4/11/15 by jrm @ Riesam LLC to fix incompatibilities with Xcode 6.3
//

import Foundation

// holds the network url and aspectRatio of an image attached to a Tweet
// created automatically when a Tweet object is created

public struct MediaItem
{
    //jrm removed 4/11/15
    //public let url: NSURL!
    //public let aspectRatio: Double = 0
    
    //jrm added 4/11/15
    public var aspectRatio: Double = 0
    public var url: NSURL!
    
    public var description: String { return (url.absoluteString ?? "no url") + " (aspect ratio = \(aspectRatio))" }
    
    // MARK: - Private Implementation

    init?(data: NSDictionary?) {
        var valid = false
        //if let urlString = data?.valueForKeyPath(TwitterKey.MediaURL) as? NSString { //jrm removed 4/11/15
        if let urlString = data?.valueForKeyPath(TwitterKey.MediaURL) as AnyObject? as? String { //jrm added 4/11/15
            if let url = NSURL(string: urlString) {
                self.url = url
                let h = data?.valueForKeyPath(TwitterKey.Height) as? NSNumber
                let w = data?.valueForKeyPath(TwitterKey.Width) as? NSNumber
                if h != nil && w != nil && h?.doubleValue != 0 {
                    aspectRatio = w!.doubleValue / h!.doubleValue
                    valid = true
                }
            }
        }
        if !valid {
            return nil
        }
    }
    
    struct TwitterKey {
        static let MediaURL = "media_url_https"
        static let Width = "sizes.small.w"
        static let Height = "sizes.small.h"
    }
}
