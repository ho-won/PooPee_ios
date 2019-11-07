//
//  PopupMenu.swift
//  PooPee_ios
//
//  Created by ho2 on 2019/11/05.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit

class PopupMenu: BaseDialog {
    @IBOutlet var root_view: UIView!
    @IBOutlet weak var layout_dialog: UIView!
    @IBOutlet var layout_dialog_top: NSLayoutConstraint!
    @IBOutlet var layout_dialog_trailing: NSLayoutConstraint!
    @IBOutlet var stack_view: UIStackView!
    
    var onMenuItemClick: (_ menuItem: MenuItem)->()
    var menuItems: [MenuItem] = []
    var y: CGFloat = 0
    
    init(view: UIView, menuItems: [MenuItem], onMenuItemClick: @escaping (_ menuItem: MenuItem)->()){
        self.menuItems = menuItems
        self.onMenuItemClick = onMenuItemClick
        
        if (view.superview! == ObserverManager.root.view) {
            let frame = view.frame
            y = frame.origin.y + view.frame.height
        } else {
            let frame = view.superview!.convert(view.frame, from: ObserverManager.root.view)
            y = -frame.origin.y + view.frame.height
        }
        
        super.init(frame: CGRect(x: 0, y: 0, width: MyUtil.screenWidth, height: MyUtil.screenHeight))
        onCreate()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        Bundle.main.loadNibNamed("PopupMenu", owner: self, options: nil)
        addSubview(root_view)
        
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        root_view.frame = self.bounds
        
        root_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        layout_dialog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_dialog_tap(recognizer:))))
        
        layout_dialog_top.constant = y
        
        setMenu()
    }
    
    func setMenu() {
        for menuItem in menuItems {
            let button = UIButton()
            button.setTitle(menuItem.title, for: .normal)
            button.setTitleColor(colors.text_main, for: .normal)
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
            button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
            button.setOnClickListener {
                self.dismiss()
                self.onMenuItemClick(menuItem)
            }
            
            stack_view.addArrangedSubview(button)
        }
        for subView in stack_view.subviews {
            NSLayoutConstraint.activate([
                subView.topAnchor.constraint(equalTo: stack_view.topAnchor, constant: 0),
                subView.bottomAnchor.constraint(equalTo: stack_view.bottomAnchor, constant: 0)
            ])
        }
        stack_view.setVisibility(gone: false, dimen: 0, attribute: .width)
    }
    
}

class MenuItem {
    var id: Int = 0
    var title: String = ""
    
    init(id: Int, title: String){
        self.id = id
        self.title = title
    }
}
