//
//  ViewController.swift
//  瀑布流WaterfallLayout
//
//  Created by Yue Zhou on 2/18/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import MJExtension
import MJRefresh

private let ADShopId = "shop"
private let total = 50

class ViewController: UIViewController, UICollectionViewDataSource, ADWaterfallLayoutDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView)
        
        setupRefresh()
    }
    
    
    // 设置刷新模块
    private func setupRefresh() {
        // header
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewShops))
        self.collectionView.mj_header.beginRefreshing()
        
        // footer
        self.collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreShops))
    }
    
    
    // MARK: Selectors
    // 下拉刷新加载
    @objc private func loadNewShops() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { 
//            let shops = ADShop.mj_objectArray(withFilename: "1.plist")
//            self.shops.removeAllObjects()
//            self.shops.addObjects(from: (shops! as NSArray) as! [Any])
            
            let shops = ADShop.objectsWithFile(named: "1.plist") as! [ADShop]
            self.shops.removeAll()
            self.shops.append(contentsOf: shops)
            
            // 刷新数据
            self.collectionView.reloadData()
            
            // 结束刷新
            self.collectionView.mj_header.endRefreshing()
        }
    }
    
    // 上拉刷新加载更多
    @objc private func loadMoreShops() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            let shops = ADShop.mj_objectArray(withFilename: "1.plist")
            let shops = ADShop.objectsWithFile(named: "1.plist") as! [ADShop]
//            self.shops.addObjects(from: (shops! as NSArray) as! [Any])
            
            self.shops.append(contentsOf: shops)
            
            // 刷新数据
            self.collectionView.reloadData()
            
            // 结束刷新
            self.collectionView.mj_footer.endRefreshing()
        }
    }
    
    
    // MARK: UICollectionViewDataSource 数据源
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shops.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ADShopId, for: indexPath) as! ADShopCell
        
        cell.shop = self.shops[indexPath.item]
        
        // 避免cell上的数字出现重用问题
//        let tag = 10
//        var label = cell.contentView.viewWithTag(tag) as? UILabel
//        if label == nil {
//            label = UILabel()
//            label!.tag = tag
//            cell.contentView.addSubview(label!)
//        }
//        label!.text = "\(indexPath.item)"
//        label!.sizeToFit()
        
//        print(cell.contentView.subviews)
        
        var label = UILabel()
        if cell.contentView.subviews.count > 2 {
            label = cell.contentView.subviews[2] as! UILabel
        }
        else {
            cell.contentView.addSubview(label)
        }
        label.text = "\(indexPath.item)"
        label.sizeToFit()
        return cell
    }
    
    
    // MARK: waterfallLayoutDelegate
    func waterfallLayout(_ layout: ADWaterfallLayout, heightForItemAt indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        let shop: ADShop = self.shops[indexPath.item]
        return itemWidth * CGFloat(shop.h!) / CGFloat(shop.w!)
    }
    
    internal var rowMarginOfWaterflowLayout: CGFloat {
        return 20
    }
    
    internal var columnCountOfWaterflowLayout: CGFloat {
        return 4
    }
    
    internal var edgeInsetsOfWaterflowLayout: UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 10, bottom: 20, right: 10)
    }


    // MARK: lazy initialization 懒加载
    lazy var collectionView: UICollectionView = {
        let layout = ADWaterfallLayout()
        layout.delegate = self
        let clv: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        clv.backgroundColor = UIColor.white
        clv.dataSource = self
        
        // 通过xib加载的ADShopCell, 而不是class
//        clv.register(ADShopCell.self, forCellWithReuseIdentifier: ADShopId)
        
        clv.register(UINib(nibName: "ADShopCell", bundle: nil), forCellWithReuseIdentifier: ADShopId)
        return clv
    }()
    
    
//    lazy var shops: NSMutableArray = {
////        let shops: [ADShop] = ADShop.objectsWithFile(named: "1.plist") as! [ADShop]
//        let shops = ADShop.mj_objectArray(withFilename: "1.plist")
//        return shops!
//    }()
    
    
    lazy var shops: [ADShop] = {
        let shops: [ADShop] = ADShop.objectsWithFile(named: "1.plist") as! [ADShop]
//        print(shops)
        return shops
    }()
}

