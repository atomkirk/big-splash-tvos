//
//  PhotoSearchService.swift
//  Spoken
//
//  Created by Adam Kirk on 10/15/15.
//  Copyright © 2015 Spoken. All rights reserved.
//

import Foundation
import ATKShared

class PhotoSearchService {
    
    typealias PhotoSearchServiceCompletionBlock = (photos: [Photo]) -> Void

    struct Photo {
        let size: CGSize
        let fullSizeURL: NSURL
        let thumbnailURL: NSURL
    }
    
    private var page: Int = 1
    
    func next(completion: PhotoSearchServiceCompletionBlock) {
        Q.background {
            let url = NSURL(string: "http://big-splash-cdn.s3-us-west-2.amazonaws.com/\(self.page++).json")!
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let
                    HTTPResponse = response as? NSHTTPURLResponse,
                    data = data
                    where HTTPResponse.statusCode == 200 {
                        if let json = JSON.fromData(data).json {
                            var newPhotos = [Photo]()
                            for photo in json.array! {
                                if let wv = photo["width"].integer,
                                    let hv = photo["height"].integer,
                                    let thumbURL = photo["urls"]["thumb"].url,
                                    let regularURL = photo["urls"]["regular"].url {
                                        let width = CGFloat(wv)
                                        let height = CGFloat(hv)
                                        newPhotos.append(Photo(size: CGSize(width: width, height: height), fullSizeURL: regularURL, thumbnailURL: thumbURL))
                                }
                            }
                            Q.main {
                                completion(photos: newPhotos)
                            }
                        }
                }
            })
            task.resume()

//            if let path = NSBundle.mainBundle().pathForResource("\(self.page++)", ofType: "json") {
//                let data = NSFileManager.defaultManager().contentsAtPath(path)
//                var newPhotos = [Photo]()
//                if let data = data, json = JSON.fromData(data).json {
//                    for photo in json.array! {
//                        if let wv = photo["width"].integer,
//                            let hv = photo["height"].integer,
//                            let thumbURL = photo["urls"]["thumb"].url,
//                            let regularURL = photo["urls"]["regular"].url {
//                                let width = CGFloat(wv)
//                                let height = CGFloat(hv)
//                                newPhotos.append(Photo(size: CGSize(width: width, height: height), fullSizeURL: regularURL, thumbnailURL: thumbURL))
//                        }
//                    }
//                    Q.main {
//                        completion(photos: newPhotos)
//                    }
//                }
//            }
        }
    }
    
}
