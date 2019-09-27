//
//  ViewPager.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 9. 7..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

class HoViewPager: UIView, UIScrollViewDelegate {
    var layout_bg = UIView()
    var scroll_view = UIScrollView()
    var stack_view = UIStackView()
    
    var stack_view_bottom: NSLayoutConstraint!
    var stack_view_leading: NSLayoutConstraint!
    var stack_view_leading_origin: CGFloat!
    
    var onHoViewPagerPageChange: ((_ position: Int) -> ())! = nil
    var onHoViewPagerHide: (()->())! = nil
    
    private var tabList: [HoTab]! = nil // 탭 목록(선택)
    private var itemList: [UIView] = [] // 아이템뷰 목록(필수)
    
    private var currentItem = 0 // 현재 아이템 position
    private var isPagingEnabled = true // 페이징처리
    
    private var view_interval: CGFloat = 0 // 뷰 간격
    private var view_interval_right: CGFloat = 0 // 좌우 뷰 보이는 넓이
    private var view_padding_top_bottom: CGFloat = 0 // 뷰의 top bottom margin
    private var view_width: CGFloat! = nil // 뷰의 넓이 (nil 이면 가운데정렬 nil이 아니면 view_interval 기준 왼쪽정렬)
    
    private var tab_title_on_color: UIColor = .black // 선택된 탭 제목 색상
    private var tab_title_off_color: UIColor = .gray // 기본 탭 제목 색상
    
    private var tab_indicator: UIView! = nil // 탭 하단 indicator
    private var tab_indicator_height: CGFloat = 0 // tab_indicator 높이
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    func _init() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        
        layout_bg = UIView()
        scroll_view = UIScrollView()
        stack_view = UIStackView()
        
        layout_bg.backgroundColor = .black
        layout_bg.alpha = 0.3
        layout_bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        
        scroll_view.isPagingEnabled = isPagingEnabled
        scroll_view.delegate = self
        
        scroll_view.removeGestureRecognizer(scroll_view.panGestureRecognizer)
        self.addGestureRecognizer(scroll_view.panGestureRecognizer)
        
        stack_view.axis = .horizontal
        
        self.addSubview(layout_bg)
        self.addSubview(scroll_view)
        self.addSubview(stack_view)
    }
    
    @objc private func layout_bg_tap(recognizer: UITapGestureRecognizer) {
        hideView()
    }
    
    @objc private func tab_tap(recognizer: TabRecongnizer) {
        setTabSelected(position: recognizer.position)
        setCurrentItem(position: recognizer.position)
    }
    
    func setupSlideScrollView(slides : [UIView]) {
        if (tab_indicator != nil) {
            tab_indicator.frame = CGRect(x: 0.0, y: (tab_indicator.superview?.frame.height)! - tab_indicator_height, width: self.frame.width / CGFloat(slides.count), height: tab_indicator_height)
        }
        
        if (view_interval == 0) {
            layout_bg.isHidden = true
        } else {
            layout_bg.isHidden = false
        }
        
        for subView in scroll_view.subviews {
            subView.removeFromSuperview()
        }
        
        for subView in stack_view.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        scroll_view.topAnchor.constraint(equalTo: scroll_view.superview!.topAnchor, constant: view_padding_top_bottom).isActive = true
        scroll_view.bottomAnchor.constraint(equalTo: scroll_view.superview!.bottomAnchor, constant: -view_padding_top_bottom).isActive = true
        
        stack_view.spacing = view_interval
        stack_view.topAnchor.constraint(equalTo: stack_view.superview!.topAnchor, constant: view_padding_top_bottom).isActive = true
        stack_view_bottom = NSLayoutConstraint(item: stack_view, attribute: .bottom, relatedBy: .equal, toItem: stack_view.superview, attribute: .bottom, multiplier: 1.0, constant: -view_padding_top_bottom)
        stack_view_bottom.isActive = true
        
        stack_view_leading_origin = view_interval_right + view_interval
        stack_view_leading = NSLayoutConstraint(item: stack_view, attribute: .leading, relatedBy: .equal, toItem: stack_view.superview, attribute: .leading, multiplier: 1.0, constant: stack_view_leading_origin)
        stack_view_leading.isActive = true
        
        if (view_width == nil) {
            scroll_view.leadingAnchor.constraint(equalTo: scroll_view.superview!.leadingAnchor, constant: view_interval_right + (view_interval / 2)).isActive = true
            scroll_view.widthAnchor.constraint(equalToConstant: self.frame.width - (view_interval_right * 2 + view_interval)).isActive = true
        } else {
            scroll_view.leadingAnchor.constraint(equalTo: scroll_view.superview!.leadingAnchor, constant: view_interval / 2).isActive = true
            scroll_view.widthAnchor.constraint(equalToConstant: view_width + view_interval).isActive = true
        }
        
        stack_view.frame.size.width = scroll_view.frame.width * CGFloat(slides.count)
        
        layoutIfNeeded()
        
        scroll_view.setContentOffset(CGPoint(x: -scroll_view.contentInset.left, y: 0), animated: false)
        scroll_view.contentSize = CGSize(width: scroll_view.frame.width * CGFloat(slides.count), height: scroll_view.frame.height)
        
        for i in 0 ..< slides.count {
            let view = UIView(frame: CGRect(x: scroll_view.frame.width * CGFloat(i), y: 0, width: scroll_view.frame.width, height: scroll_view.frame.height))
            view.backgroundColor = nil
            scroll_view.addSubview(view)
            stack_view.addArrangedSubview(slides[i])
        }
        for subView in stack_view.subviews {
            subView.widthAnchor.constraint(equalToConstant: scroll_view.frame.width - view_interval).isActive = true
            subView.topAnchor.constraint(equalTo: stack_view.topAnchor, constant: 0).isActive = true
            subView.bottomAnchor.constraint(equalTo: stack_view.bottomAnchor, constant: 0).isActive = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentItem = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        if (tabList != nil) {
            setTabSelected(position: currentItem)
        }
        if (onHoViewPagerPageChange != nil) {
            onHoViewPagerPageChange(currentItem)
        }
        
        let per = (scrollView.contentOffset.x / scrollView.contentSize.width) * 100
        stack_view_leading.constant = stack_view_leading_origin - scrollView.contentOffset.x
        
        if (tab_indicator != nil) {
            tab_indicator.frame.origin.x = (per / 100) * self.frame.width
        }
    }
    
    func showView() {
        self.isHidden = false
    }
    
    func hideView() {
        self.isHidden = true
    }
    
    func setListener(onHoViewPagerPageChange: @escaping (_ position: Int) -> (), onHoViewPagerHide: @escaping () -> ()) {
        self.onHoViewPagerPageChange = onHoViewPagerPageChange
        self.onHoViewPagerHide = onHoViewPagerHide
    }
    
    /**
     * 세팅된 값으로 뷰페이저 세팅
     */
    func setView() {
        self.frame = self.superview!.bounds
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        layout_bg.translatesAutoresizingMaskIntoConstraints = false
        scroll_view.translatesAutoresizingMaskIntoConstraints = false
        stack_view.translatesAutoresizingMaskIntoConstraints = false
        
        layout_bg.topAnchor.constraint(equalTo: layout_bg.superview!.topAnchor, constant: 0).isActive = true
        layout_bg.bottomAnchor.constraint(equalTo: layout_bg.superview!.bottomAnchor, constant: 0).isActive = true
        layout_bg.leadingAnchor.constraint(equalTo: layout_bg.superview!.leadingAnchor, constant: 0).isActive = true
        layout_bg.trailingAnchor.constraint(equalTo: layout_bg.superview!.trailingAnchor, constant: 0).isActive = true
        
        DispatchQueue.main.async {
            self.setupSlideScrollView(slides: self.itemList)
        }
    }
    
    /**
     * 아이템뷰 추가
     */
    func addItem(item: UIView) {
        itemList.append(item)
    }
    
    /**
     * 초기화
     */
    func clear() {
        tabList = nil
        
        itemList = []
        
        currentItem = 0
        
        view_interval = 0 // 뷰 간격
        view_interval_right = 0
        view_padding_top_bottom = 0 // 뷰의 top bottom margin
        
        tab_title_on_color = .black
        tab_title_off_color = .gray
        
        tab_indicator = nil
        tab_indicator_height = 0 // tab_indicator 높이
        
        _init()
    }
    
    /**
     * 페이징 세팅
     */
    func setPagingEnabled(isPagingEnabled: Bool) {
        self.isPagingEnabled = isPagingEnabled
        scroll_view.isPagingEnabled = isPagingEnabled
    }
    
    /**
     * 여백 세팅
     */
    func setInterval(interval: CGFloat, interval_right: CGFloat = 0, padding_top_bottom: CGFloat = 0, width: CGFloat! = nil) {
        view_interval = interval
        view_interval_right = interval_right
        view_padding_top_bottom = padding_top_bottom
        view_width = width
    }
    
    /**
     * indicator 세팅
     */
    func setIndicator(indicator: UIView, color: UIColor, height: CGFloat) {
        tab_indicator = indicator
        tab_indicator.backgroundColor = color
        tab_indicator_height = height
        tab_indicator.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    /**
     * 탭 목록 세팅
     */
    func setTabList(tab_list: [HoTab], title_on_color: UIColor, title_off_color: UIColor) {
        tab_title_on_color = title_on_color
        tab_title_off_color = title_off_color
        tabList = tab_list
        
        for i in 0 ..< tabList.count {
            let gesture = TabRecongnizer(target: self, action: #selector(tab_tap(recognizer:)))
            gesture.position = i
            tabList[i].tab_view.addGestureRecognizer(gesture)
        }
    }
    
    /**
     * 탭 선택
     */
    func setTabSelected(position: Int) {
        for tab in tabList {
            tab.tab_title.textColor = tab_title_off_color
        }
        tabList[position].tab_title.textColor = tab_title_on_color
    }
    
    /**
     * 특정 아이템뷰로 이동
     */
    func setCurrentItem(position: Int) {
        currentItem = position
        
        DispatchQueue.main.async {
            let desiredOffset = CGPoint(x: self.scroll_view.frame.width * CGFloat(position), y: 0)
            self.scroll_view.setContentOffset(desiredOffset, animated: true)
        }
    }
    
    /**
     * 현재 아이템뷰 position
     */
    func getCurrentItem() -> Int {
        return currentItem
    }
    
    /**
     * 아이템뷰 전체 카운트
     */
    func getItemCount() -> Int {
        return itemList.count
    }
    
    /**
     * 아이템뷰 목록
     */
    func getItems() -> [UIView] {
        return itemList
    }
    
}

protocol onHoViewPagerListener {
    func onHoViewPagerPageChange(position: Int)
    func onHoViewPagerHide()
}
