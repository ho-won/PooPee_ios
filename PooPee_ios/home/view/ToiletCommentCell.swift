//
//  ToiletCommentCell.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/10/28.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit

class ToiletCommentCell: UITableViewCell {
    @IBOutlet var root_view: UIView!
    
    @IBOutlet var iv_gender: UIImageView!
    @IBOutlet var tv_name: UILabel!
    @IBOutlet var tv_date: UILabel!
    @IBOutlet var tv_comment: UILabel!
    @IBOutlet var btn_menu: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
