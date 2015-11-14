//
//  PhotoSearchVC.swift
//  Spoken
//
//  Created by Adam Kirk on 10/5/15.
//  Copyright © 2015 Spoken. All rights reserved.
//

import UIKit
import ATKShared

private let cellIdentifier = "PhotoCell"

class PhotosCollectionViewController: UICollectionViewController, MasonryLayoutDelegate {
    
    var photoService = PhotoSearchService()
    
    var photos: [PhotoSearchService.Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? MasonryLayout {
            layout.delegate = self
        }
        
            self.loadMorePhotos {
//                StatusHUD.dismissWithCompletion()
                self.loadMorePhotos()
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FullScreenImageSegue" {
            if let controller = segue.destinationViewController as? PhotoPageViewController {
                controller.photos = photos
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let thumbWidth = (self.collectionView!.width / 2.0) - 2.5
        return (thumbWidth / photo.size.width) * photo.size.height
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
