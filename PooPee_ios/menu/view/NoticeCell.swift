//
//  NoticeCell.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/11/19.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {
    @IBOutlet var root_view: UIView!
    @IBOutlet var layout_title: UIView!
    @IBOutlet var tv_title: UILabel!
    @IBOutlet var tv_date: UILabel!
    @IBOutlet var layout_content: UIView!
    @IBOutlet var tv_content: UILabel!
    @IBOutlet var cb_detail: cb_up_down_notice!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout_content.setVisibility(gone: true, dimen: 0, attribute: .height)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
