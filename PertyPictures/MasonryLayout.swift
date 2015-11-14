//
//  MasonryLayout.swift
//  Spoken
//
//  Created by Adam Kirk on 10/6/15.
//  Copyright © 2015 Spoken. All rights reserved.
//

import UIKit
import ATKSharedUIKit

public protocol MasonryLayoutDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

public class MasonryLayout: UICollectionViewLayout {
    
    @IBInspectable public var padding = CGFloat(3)
    
    public var delegate: MasonryLayoutDelegate!
    
    private var items = [UICollectionViewLayoutAttributes]()
    
    private let columnCount = 2
    
    public override func prepareLayout() {
        super.prepareLayout()
        
        let columnWidth = collectionView!.width / CGFloat(columnCount)
        let w = columnWidth - (padding * (CGFloat(columnCount) - 1))
        
        for i in items.count..<collectionView!.numberOfItemsInSection(0) {
            let ip = NSIndexPath(forItem: i, inSection: 0)
            let column = i % columnCount
            
            let h = delegate.collectionView(collectionView!, layout: self, heightForItemAtIndexPath: ip)
            let x = (w + padding) * CGFloat(column)
            let y: CGFloat = {
                if i < columnCount {
                    return 0
                }
                else {
                    let lastItem = items[i - columnCount]
                    return CGRectGetMaxY(lastItem.frame) + padding
                }
            }()
            
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: ip)
            attributes.frame = CGRect(x: x, y: y, width: w, height: h)
            items.append(attributes)
        }
    }
    
    public override func collectionViewContentSize() -> CGSize {
        var maxHeight = CGFloat(0)
        for item in items {
            let h = CGRectGetMaxY(item.frame)
            if h > maxHeight {
                maxHeight = h
            }
        }
        return CGSize(width: collectionView!.width, height: maxHeight)
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return items.filter { CGRectIntersectsRect($0.frame, rect) }
    }

}
