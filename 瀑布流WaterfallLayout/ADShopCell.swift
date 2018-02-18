//
//  ADShopCell.swift
//  瀑布流WaterfallLayout
//
//  Created by Yue Zhou on 2/18/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SDWebImage

class ADShopCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    var shop: ADShop? {
        didSet {
            let url = URL(string: shop!.img!)!
            self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "loading"))
            self.priceLabel.text = shop!.price!
        }
    }
    
}
