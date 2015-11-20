//
//  PhotoPageViewController.swift
//  BigSplash
//
//  Created by Adam Kirk on 11/7/15.
//  Copyright © 2015 Adam Kirk. All rights reserved.
//

import UIKit
import ATKShared

protocol PhotoPageViewControllerDelegate {
    func photoPageViewController(controller: PhotoPageViewController, isReachingLastPhoto photo: PhotoSearchService.Photo)
}

class PhotoPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var photos: [PhotoSearchService.Photo] = []

    var selectedPhoto: PhotoSearchService.Photo?
    
    var photoPageDelegate: PhotoPageViewControllerDelegate?
    
    var autoSlideTimer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let controller = storyboard?.instantiateViewControllerWithIdentifier("FullScreenPhotoViewController") as? FullScreenPhotoViewController,
            let imageURL = selectedPhoto?.fullSizeURL {
                controller.imageURL = imageURL
                self.setViewControllers([controller], direction: .Forward, animated: false, completion: nil)
                preloadImagesSurrounding(controller)
        }
        self.dataSource = self
    }
    
    deinit {
        autoSlideTimer?.invalidate()
        autoSlideTimer = nil
    }
    
    
    // MARK: - Timer
    
    func slideTimerDidTick(note: NSNotification) {
        if let controller = nextController() as? FullScreenPhotoViewController {
            preloadImagesSurrounding(controller)
            setViewControllers([controller], direction: .Forward, animated: true, completion: nil)
        }
        else if photos.count > 0 {
            let photo = photos[0]
            
            if let firstController = storyboard?.instantiateViewControllerWithIdentifier("FullScreenPhotoViewController") as? FullScreenPhotoViewController {
                preloadImagesSurrounding(firstController)
                firstController.imageURL = photo.fullSizeURL
                setViewControllers([firstController], direction: .Forward, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Page Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        resetTimer()
        if let controller = viewController as? FullScreenPhotoViewController {
            preloadImagesSurrounding(controller)
            if let index = photos.indexOf({ $0.fullSizeURL == controller.imageURL }) {
                let nextIndex = index - 1
                if nextIndex >= 0 {
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
        resetTimer()
        return nextController()
    }
    
    
    // MARK: - Private
    
    private func nextController() -> UIViewController? {
        if let controller = viewControllers?.first as? FullScreenPhotoViewController {
            preloadImagesSurrounding(controller)
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
    
    private func preloadImagesSurrounding(controller: FullScreenPhotoViewController) {
        if let index = photos.indexOf({ $0.fullSizeURL == controller.imageURL }) {
            for i in max(0, index - 2)...min(index + 2, photos.count) {
                let photo = photos[i]
                print("preloaded: \(i)")
                ImageCache.shared.preloadImageAtURL(photo.fullSizeURL)
            }
        }
    }
    
    private func resetTimer() {
        autoSlideTimer?.invalidate()
        autoSlideTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "slideTimerDidTick:", userInfo: nil, repeats: true)
    }

}
