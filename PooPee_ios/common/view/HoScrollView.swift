//
//  HoScrollView.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/10/25.
//  Copyright © 2019 ho1. All rights reserved.
//

import Foundation

class HoScrollView : UIScrollView, UIScrollViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    func _init() {
        for subview in self.subviews {
            if (subview.isKind(of: HoScrollContentView.self)) {
                let hoScrollContentView = subview as! HoScrollContentView
                hoScrollContentView.setChangedListener(onChanged: {
                    print("HoScrollView onChanged:\(hoScrollContentView.frame.height)")
                })
                break
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            // let offsetY = scrollView.contentOffset.y
        }
    }
    
}

class HoScrollContentView : UIView {
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
