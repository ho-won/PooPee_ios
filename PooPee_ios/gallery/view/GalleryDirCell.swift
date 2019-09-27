//
//  GalleryDirCell.swift
//  CarTrader
//
//  Created by Jung ho Seo on 2018. 6. 20..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit

class GalleryDirCell: UITableViewCell {
    @IBOutlet weak var tv_title: UILabel!
}

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var iv_image: UIImageView!
    @IBOutlet weak var layout_select: UIView!
    @IBOutlet weak var tv_index: UILabel!
    
    func setImage(image: UIImage) {
        iv_image.image = image
        
        layout_select.layer.borderColor = UIColor(hex: "#3F526A")?.cgColor
        layout_select.layer.borderWidth = 3
        
        tv_index.backgroundColor = UIColor(hex: "#3F526A")
        tv_index.cornerRadius(corner: [.allCorners], radius: 12)
    }
}
