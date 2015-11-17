//
//  PhotoPageViewController.swift
//  BigSplash
//
//  Created by Adam Kirk on 11/7/15.
//  Copyright © 2015 Adam Kirk. All rights reserved.
//

import UIKit

protocol PhotoPageViewControllerDelegate {
    func photoPageViewController(controller: PhotoPageViewController, isReachingLastPhoto photo: PhotoSearchService.Photo)
}

class PhotoPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var photos: [PhotoSearchService.Photo] = []

    var selectedPhoto: PhotoSearchService.Photo?
    
    var photoPageDelegate: PhotoPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let controller = storyboard?.instantiateViewControllerWithIdentifier("FullScreenPhotoViewController") as? FullScreenPhotoViewController,
            let imageURL = selectedPhoto?.fullSizeURL {
                controller.imageURL = imageURL
                self.setViewControllers([controller], direction: .Forward, animated: false, completion: nil)
        }
        self.dataSource = self
    }
    
    
    // MARK: - Page Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? FullScreenPhotoViewController {
            if let index = photos.indexOf({ $0.fullSizeURL == controller.imageURL }) {
                let nextIndex = index - 1
                if nextIndex > 0 {
                    let photo = photos[nextIndex]
                    if let nextController = storyboard?.instantiateViewControllerWithIdentifier("FullScreenPhotoViewController") as? FullScreenPhotoViewController {
                        nextController.imageURL = photo.fullSizeURL
                        return nextController
                    }
                }
            }
        }
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? FullScreenPhotoViewController {
            if let index = photos.indexOf({ $0.fullSizeURL == controller.imageURL }) {
                let nextIndex = index + 1
                if nextIndex < photos.count {
                    let photo = photos[nextIndex]
                    
                    if photos.count - nextIndex < 10 {
                        photoPageDelegate?.photoPageViewController(self, isReachingLastPhoto: photo)
                    }
                    
                    if let nextController = storyboard?.instantiateViewControllerWithIdentifier("FullScreenPhotoViewController") as? FullScreenPhotoViewController {
                        nextController.imageURL = photo.fullSizeURL
                        return nextController
                    }
                }
            }
        }
        return nil
    }

}
