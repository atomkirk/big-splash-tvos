//
//  FullScreenPhotoViewController.swift
//  BigSplash
//
//  Created by Adam Kirk on 11/7/15.
//  Copyright © 2015 Adam Kirk. All rights reserved.
//

import UIKit
import ATKShared

class FullScreenPhotoViewController: UIViewController {

    var imageURL: NSURL?

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = imageURL {
            ImageCache.shared.loadImageAtURL(url) { originalURL, cached, image in
                self.imageView.image = image
                // decide if image should be scaled to fit or fill
                // If the aspect ratio is drastic (meaning it's super long or super tall, then scale to fit (show black bars where it doesn't fill)
                let aspectRatio = image.size.height / image.size.width
//                print("width: \(image.size.width)")
//                print("height: \(image.size.height)")
//                print("ratio: \(aspectRatio)")
                if aspectRatio >= 1.0 {
                    self.imageView.contentMode = .ScaleAspectFit
                }
                else {
                    self.imageView.contentMode = .ScaleAspectFill
                }
            }
        }
    }

}
