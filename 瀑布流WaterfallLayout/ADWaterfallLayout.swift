//
//  ADWaterfallLayout.swift
//  瀑布流WaterfallLayout
//
//  Created by Yue Zhou on 2/18/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

private let ADColumnCount: CGFloat = 3
private let ADColumnMargin: CGFloat = 10
private let ADRowMargin: CGFloat = 10
private let ADEdgeInset: UIEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 20, right: 10)

class ADWaterfallLayout: UICollectionViewLayout {

    // 初始化
    override func prepare() {
        super.prepare()
        
        // 清除所有以前计算过的高度
        self.columnHeights.removeAll()
        
        // 初始化一定高度
        for _ in 0..<Int(ADColumnCount) {
            self.columnHeights.append(ADEdgeInset.top)
        }
        
        // 清除之前所有的布局属性, 否则attrs数组越来越大
        self.attrsArray.removeAll()
        
        // 自定义每一个cell的布局属性
        let count: Int = self.collectionView!.numberOfItems(inSection: 0)
        for i in 0..<count {
            let indexPath = IndexPath(item: i, section: 0)
            
            // 获取indexPath位置cell的布局属性
            let attrs = self.layoutAttributesForItem(at: indexPath)
            self.attrsArray.append(attrs!)
        }
    }
    
    
    /**
     * 决定cell的排布. 很重要
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attrsArray
    }
    
    /**
     * 返回indexPath的cell的布局属性
     */
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // 初始化布局
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        // collectionView宽度
        let clvWid = self.collectionView!.frame.width
        
        // 设置布局属性中的frame
        let w: CGFloat = (clvWid - ADEdgeInset.left - ADEdgeInset.right - (ADColumnCount - 1) * ADColumnMargin) / ADColumnCount
        let h: CGFloat = 50.0 + CGFloat(arc4random_uniform(100))

        // 找出最短列的index和其高度
        let (minHeightColumn, minHeight) = self.getMinHeight(heights: self.columnHeights)
        
        let x: CGFloat = ADEdgeInset.left + CGFloat(minHeightColumn) * (w + ADColumnMargin)
        let y: CGFloat = minHeight
        
        // 赋值frame
        attrs.frame = CGRect(x: x, y: y, width: w, height: h)
        
        // 更新最短列的高度
        self.columnHeights[minHeightColumn] = attrs.frame.maxY + ADColumnMargin
        
        return attrs
    }
    
    
    /**
     * 返回collectionView的contentSize
     */
    override var collectionViewContentSize: CGSize {
        get {
            // 根据最高一列来决定
            return CGSize(width: 0, height: self.getMaxHeight(heights: self.columnHeights) + ADEdgeInset.bottom - ADColumnMargin)
        }
    }
    
    
    /**
     * 找出一个数组中的最小数的index和值
     */
    private func getMinHeight(heights: [CGFloat]) -> (Int, CGFloat) {
        var minHeight = heights.first!
        var minIndex = 0
        
        for i in 1..<heights.count {
            if heights[i] < minHeight {
                minHeight = heights[i]
                minIndex = i
            }
        }
        return (minIndex, minHeight)
    }
    
    
    /**
     * 找出一个数组中的最小数的index和值
     */
    private func getMaxHeight(heights: [CGFloat]) -> CGFloat {
        var maxHeight = heights.first!
        
        for i in 1..<heights.count {
            if heights[i] > maxHeight {
                maxHeight = heights[i]
            }
        }
        return maxHeight
    }
    
    // MARK: 懒加载
    
    // 存放所有cell的布局属性
    lazy var attrsArray = [UICollectionViewLayoutAttributes]()
    
    // 存放所有列的高度(最大Y值)
    lazy var columnHeights = [CGFloat]()
}
