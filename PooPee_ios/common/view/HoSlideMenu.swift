import UIKit

class HoSlideMenu: UIView, UIScrollViewDelegate {
    let layout_bg = UIView() // 반투명 배경
    let scroll_view = UIScrollView()
    
    var isLeft = true
    var positionOpen = 0 // 0(왼쪽메뉴) 1(오른쪽메뉴)
    var positionClose = 1 // 1(왼쪽메뉴) 0(오른쪽메뉴)
    
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
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        
        addSubview(layout_bg)
        addSubview(scroll_view)
        
        layout_bg.frame = self.bounds
        layout_bg.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        layout_bg.backgroundColor = .black
        layout_bg.alpha = 0.3
        
        scroll_view.frame = self.bounds
        scroll_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scroll_view.bounces = false
        
        scroll_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        if (currentPage == positionClose) {
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
            UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.scroll_view.contentOffset.x = self.scroll_view.frame.width * CGFloat(position)
                if (position == self.positionClose) {
                    self.layout_bg.alpha = 0
                } else {
                    self.layout_bg.alpha = 0.3
                }
            }, completion: { (finished: Bool) in
                if (position == self.positionClose) {
                    self.isHidden = true
                }
            })
        }
    }
    
    func setMenuView(_ menu_view: UIView, _ menu_width: CGFloat, _ isLeft: Bool) {
        self.isLeft = isLeft
        if (isLeft) {
            positionOpen = 0
            positionClose = 1
        } else {
            positionOpen = 1
            positionClose = 0
        }
        layoutIfNeeded()
        DispatchQueue.main.async {
            self.scroll_view.setContentOffset(CGPoint(x: -self.scroll_view.contentInset.left, y: 0), animated: false)
            self.scroll_view.contentSize = CGSize(width: self.scroll_view.frame.width * 2, height: self.scroll_view.frame.height)
            self.scroll_view.isPagingEnabled = true
            self.scroll_view.delegate = self
            
            if (self.isLeft) {
                menu_view.frame = CGRect(x: 0, y: 0, width: menu_width, height: self.frame.height)
                menu_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.none_tap(recognizer:))))
                
                let rightView = UIView()
                rightView.backgroundColor = nil
                rightView.frame = CGRect(x: self.scroll_view.frame.width, y: 0, width: self.scroll_view.frame.width, height: self.frame.height)
                
                self.scroll_view.addSubview(menu_view)
                self.scroll_view.addSubview(rightView)
            } else {
                menu_view.frame = CGRect(x: self.scroll_view.frame.width + (self.scroll_view.frame.width - menu_width), y: 0, width: menu_width, height: self.frame.height)
                menu_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.none_tap(recognizer:))))
                
                let rightView = UIView()
                rightView.backgroundColor = nil
                rightView.frame = CGRect(x: 0, y: 0, width: self.scroll_view.frame.width, height: self.frame.height)
                
                self.scroll_view.addSubview(rightView)
                self.scroll_view.addSubview(menu_view)
            }
            
            self.hideMenu()
        }
    }
    
    func showMenu() {
        self.isHidden = false
        setCurrentPage(position: positionOpen)
    }
    
    func hideMenu() {
        setCurrentPage(position: positionClose)
    }
    
}
