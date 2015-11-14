//
//  PhotoSearchVC.swift
//  Spoken
//
//  Created by Adam Kirk on 10/5/15.
//  Copyright © 2015 Spoken. All rights reserved.
//

import UIKit
import ATKShared
import ATKSharedUIKit

private let cellIdentifier = "PhotoCell"

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photoService = PhotoSearchService()
    
    var photos: [PhotoSearchService.Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadMorePhotos {
            self.loadMorePhotos()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FullScreenImageSegue" {
            if let controller = segue.destinationViewController as? PhotoPageViewController {
                if let ip = collectionView?.indexPathsForSelectedItems()?.first {
                    controller.selectedPhoto = photos[ip.item]
                    controller.photos = photos
                }
            }
        }
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photo = photos[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        if let cell = cell as? PhotoCell {
            cell.imageURL = photo.thumbnailURL
        }
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if collectionView!.isWithinPoints(50, toEdge: UIRectEdge.Bottom) {
            loadMorePhotos()
        }
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // how many times do photos fit if they are of width 200?
        let minPhotos = Int(round(collectionView.width / 200.0))
        // figure out with of one higher
        let dim = CGFloat(collectionView.width / CGFloat(minPhotos + 1))
        
        return CGSize(width: dim, height: dim)
    }
    
    
    // MARK: - Private
    
    private func loadMorePhotos(completion: (() -> Void)? = nil) {
        self.photoService.next { newPhotos in
            self.photos += newPhotos
            self.collectionView?.reloadData()
            completion?()
        }
    }
    
}
