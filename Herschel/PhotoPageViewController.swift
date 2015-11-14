//
//  PhotoPageViewController.swift
//  Herschel
//
//  Created by Adam Kirk on 11/7/15.
//  Copyright © 2015 Adam Kirk. All rights reserved.
//

import UIKit

class PhotoPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var photos: [PhotoSearchService.Photo] = []
    
    var selectedPhoto: PhotoSearchService.Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let controller = storyboard?.instantiateViewControllerWithIdentifier("FullScreenPhotoViewController") as? FullScreenPhotoViewController,
            let imageURL = selectedPhoto?.fullSizeURL {
                controller.imageURL = imageURL
                self.setViewControllers([controller], direction: .Forward, animated: false, completion: nil)
        }
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }

}
