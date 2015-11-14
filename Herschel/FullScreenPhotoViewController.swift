//
//  FullScreenPhotoViewController.swift
//  Herschel
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
                if originalURL == self.imageURL {
                    self.imageView.image = image
                }
            }
        }
    }

}
