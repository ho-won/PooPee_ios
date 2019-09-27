//
//  HoSlideMenu.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 7..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

class HoSlideMenu: UIView, UIScrollViewDelegate {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_bg: UIView! // 반투명 배경
    @IBOutlet weak var scroll_view: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    func _init() {
        self.isHidden = true
        Bundle.main.loadNibNamed("HoSlideMenu", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        root_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        scroll_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        if (currentPage == 1) {
            hideMenu()
        }
    }
    
    /**
     * 슬라이드메뉴 배경 클릭시 메뉴 사라지게
     */
    @objc private func layout_bg_tap(recognizer: UITapGestureRecognizer) {
        hideMenu()
    }
    
    /**
     * 슬라이드메뉴 클릭시 메뉴 안사라지게
     */
    @objc private func none_tap(recognizer: UITapGestureRecognizer) {
        
    }
    
    private func setCurrentPage(position: Int) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.scroll_view.contentOffset.x = self.scroll_view.frame.width * CGFloat(position)
                if (position == 1) {
                    self.layout_bg.alpha = 0
                } else {
                    self.layout_bg.alpha = 0.3
                }
            }, completion: { (finished: Bool) in
                if (position == 1) {
                    self.isHidden = true
                }
            })
        }
    }
    
    func setMenuView(menu_view: UIView, menu_width: CGFloat) {
        layoutIfNeeded()
        DispatchQueue.main.async {
            self.scroll_view.setContentOffset(CGPoint(x: -self.scroll_view.contentInset.left, y: 0), animated: false)
            self.scroll_view.contentSize = CGSize(width: self.scroll_view.frame.width * 2, height: self.scroll_view.frame.height)
            self.scroll_view.isPagingEnabled = true
            self.scroll_view.delegate = self
            
            menu_view.frame = CGRect(x: 0, y: 0, width: menu_width, height: self.root_view.frame.height)
            menu_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.none_tap(recognizer:))))
            self.scroll_view.addSubview(menu_view)
            
            let rightView = UIView()
            rightView.backgroundColor = nil
            rightView.frame = CGRect(x: self.scroll_view.frame.width, y: 0, width: self.scroll_view.frame.width, height: self.root_view.frame.height)
            self.scroll_view.addSubview(rightView)
            self.hideMenu()
        }
    }
    
    func showMenu() {
        self.isHidden = false
        setCurrentPage(position: 0)
    }
    
    func hideMenu() {
        setCurrentPage(position: 1)
    }
    
}
