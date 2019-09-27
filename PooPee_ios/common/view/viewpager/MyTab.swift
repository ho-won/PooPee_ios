//
//  MyTab.swift
//  Test
//
//  Created by Jung ho Seo on 2018. 11. 2..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

class MyTab: UIView {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_tab: UIView!
    @IBOutlet weak var tv_title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    func _init() {
        Bundle.main.loadNibNamed("MyTab", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = layout_tab.frame.width
        root_view.frame = self.bounds
    }
    
    func setTitle(title: String) {
        tv_title.text = title
        self.layoutIfNeeded()
        self.frame.size.width = layout_tab.frame.width
        root_view.frame = self.bounds
    }
    
}
