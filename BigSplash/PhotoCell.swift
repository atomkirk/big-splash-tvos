//
//  PhotoCell.swift
//  Spoken
//
//  Created by Adam Kirk on 10/6/15.
//  Copyright © 2015 Spoken. All rights reserved.
//

import UIKit
import ATKShared

class PhotoCell: UICollectionViewCell {
    
    var count: Int = 0
    
    var imageURL: NSURL? {
        didSet {
            imageView.image = nil
            displayImageAtURL(imageURL)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func displayImageAtURL(loadURL: NSURL?) {
        if let url = loadURL {
            ImageCache.shared.loadImageAtURL(url) { originalURL, cached, image in
                if originalURL == self.imageURL {
                    self.imageView.image = image
                    if !cached {
                        self.imageView.alpha = 0
                        self.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                        UIView.animateWithDuration(0.33) {
                            self.imageView.alpha = 1
                        }
                        UIView.animateWithDuration(0.5) {
                            self.imageView.transform = CGAffineTransformIdentity
                        }
                    }
                }
            }
        }
    }
    
}
