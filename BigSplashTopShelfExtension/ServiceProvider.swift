//
//  ServiceProvider.swift
//  BigSplashTopShelfExtension
//
//  Created by Adam Kirk on 11/20/15.
//  Copyright © 2015 Adam Kirk. All rights reserved.
//

import Foundation
import TVServices
import ATKShared

class ServiceProvider: NSObject, TVTopShelfProvider {
    
    override init() {
        super.init()
    }

    // MARK: - TVTopShelfProvider protocol

    var topShelfStyle: TVTopShelfContentStyle {
        // Return desired Top Shelf style.
        return .Inset
    }

    var topShelfItems: [TVContentItem] {
        // Create an array of TVContentItems.
        let url = NSURL(string: "http://big-splash-cdn.s3-us-west-2.amazonaws.com/1.json")!
        let data = NSData(contentsOfURL: url)!
        var items = [TVContentItem]()
        if let json = JSON.fromData(data).json {
            for photo in json.array! {
                if let id = photo["id"].string,
                    let regularURL = photo["urls"]["regular"].url {
                        if let item = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: id, container: nil)!) {
                            item.imageURL = regularURL
                            items.append(item)
                            if items.count > 30 {
                                break
                            }
                        }
                        
                }
            }
        }
        return items
    }

}

