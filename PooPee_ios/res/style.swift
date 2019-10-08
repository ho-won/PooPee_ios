//
//  style.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 8..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit

/*
 * 툴바뷰(primary)
 */
class toolbar: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.backgroundColor = colors.primary
    }
}

/*
 * 툴바뷰 title(primary) 
 */
class toolbar_tv_title: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.textColor = colors.toolbar_title
        self.font = UIFont.boldSystemFont(ofSize: 19)
    }
}

/*
 * 뷰(바텀라인)
 * 공통
 */
class view_bottom_line: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.addBorders(edges: [.bottom], color: colors.main_line, inset: 0, thickness: dimen.main_line_height)
    }
}

class bg_my_position: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 18
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        self.backgroundColor = colors.primary
    }
}

class bg_search_layout: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.backgroundColor = colors.main_content_background
    }
}

class bg_search_edt: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor(hex: "#F9F9F9")!
    }
}

class bg_login: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    func _init() {
        self.layer.cornerRadius = 24
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.backgroundColor = colors.main_content_background
        self.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
        setEnabled(enable: false)
    }
    
    func setEnabled(enable: Bool) {
        self.isEnabled = enable
        if (enable) {
            self.setTitleColor(colors.primary, for: .normal)
        } else {
            self.setTitleColor(UIColor(hex: "#85b3ff"), for: .normal)
        }
    }
}
