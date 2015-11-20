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
    
    // if the timer survives, load the image. Otherwise, we're scrolling fast so don't bother.
    var timer: NSTimer?
    
    var imageURL: NSURL? {
        didSet {
            imageView.image = nil
            timer?.invalidate()
            if let url = imageURL where ImageCache.shared.hasImage(url) {
                displayImageAtURL(url)
            }
            else {
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "loadImageTimerDidFire:", userInfo: nil, repeats: false)
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Timers
    
    func loadImageTimerDidFire(note: NSNotification) {
        displayImageAtURL(imageURL)
    }
    
    private func displayImageAtURL(loadURL: NSURL?) {
        if let url = loadURL {
            ImageCache.shared.loadImageAtURL(url) { originalURL, cached, image in
                if originalURL == self.imageURL {
                    self.imageView.image = image
                    if !cached {
                        self.imageView.alpha = 0
                        UIView.animateWithDuration(0.33) {
                            self.imageView.alpha = 1
                        }
                    }
                }
                else {
                    self.displayImageAtURL(self.imageURL)
                }
            }
        }
    }
    
}
