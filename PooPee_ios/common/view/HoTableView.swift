//
//  HoScrollView.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/10/25.
//  Copyright © 2019 ho1. All rights reserved.
//

import Foundation

class HoTableView : UITableView {
    var headerView: HoTableHeaderView = HoTableHeaderView()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    func _init() {
        
    }
    
    func setHeaderViewScroll(y: CGFloat) {
        DispatchQueue.main.async {
            self.headerView.frame.origin.y = y - self.headerView.frame.height
        }
    }

    func setHeaderView(headerView: HoTableHeaderView) {
        DispatchQueue.main.async {
            self.headerView = headerView
            self.contentInset = UIEdgeInsets(top: self.headerView.frame.height, left: 0, bottom: 0, right: 0)
            self.headerView.setChangedListener(onChanged: {
                self.contentInset = UIEdgeInsets(top: self.headerView.frame.height, left: 0, bottom: self.headerView.frame.height, right: 0)
            })
        }
    }
    
}

class HoTableHeaderView : UIView {
    var onChanged: ()->() = {}
    
    func setChangedListener(onChanged: @escaping ()->()) {
        self.onChanged = onChanged
    }
    
    override var bounds: CGRect {
        didSet {
            onChanged()
        }
    }
}
