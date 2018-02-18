//
//  ViewController.swift
//  瀑布流WaterfallLayout
//
//  Created by Yue Zhou on 2/18/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

private let ADShopId = "shop"
private let total = 50

class ViewController: UIViewController, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView)
        print(self.collectionView.contentSize)
    }
    
    // MARK: UICollectionViewDataSource 数据源
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return total
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ADShopId, for: indexPath)
        cell.backgroundColor = UIColor.orange
        
        let tag = 10
        var label = cell.contentView.viewWithTag(tag) as? UILabel
        if label == nil {
            label = UILabel()
            label!.tag = tag
            cell.contentView.addSubview(label!)
        }
        label!.text = "\(indexPath.item)"
        label!.sizeToFit()
        return cell
    }


    // MARK: lazy initialization 懒加载
    lazy var collectionView: UICollectionView = {
        let clv: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: ADWaterfallLayout())
        clv.dataSource = self
        clv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ADShopId)
        return clv
    }()
}

