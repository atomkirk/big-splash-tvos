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
            if let path = NSBundle.mainBundle().pathForResource("\(self.page++)", ofType: "json") {
                let data = NSFileManager.defaultManager().contentsAtPath(path)
                var newPhotos = [Photo]()
                if let data = data, json = JSON.fromData(data).json {
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
        }
    }
    
    func cachePhotosFromWebAPI() {
        fetchAndArchiveNextPageOfPhotos(0)
    }
    
    private func fetchAndArchiveNextPageOfPhotos(page: Int, photosAccumulator: [JSON] = []) {
        let url = NSURL(string: "https://api.unsplash.com/photos?page=\(page)&per_page=30&client_id=983480de6ec4cfa73aed46f5005dba2b88d804cbfcbda30f768aed7a9c81e9ed")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if let response = response as? NSHTTPURLResponse where response.statusCode == 200 {
                if let
                    data = data,
                    json = JSON.fromData(data).json,
                    photos = json.array
                    where photos.count > 0 {
                        if page > 0 && page % 10 == 0 {
                            let filename = "\(page / 10)"
                            let path = NSTemporaryDirectory() + filename + ".json"
                            let data = json.JSONData
                            data.writeToFile(path, atomically: true)
                            self.fetchAndArchiveNextPageOfPhotos(page + 1)
                        }
                        else {
                            self.fetchAndArchiveNextPageOfPhotos(page + 1, photosAccumulator: photosAccumulator + photos)
                        }
                }
                else {
                    print("done")
                }
            }
            else {
                print("\(response)")
            }
        })
        task.resume()
    }
    
}
