//
//  DirSelectDialog.swift
//  CarTrader
//
//  Created by Jung ho Seo on 2018. 6. 20..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

class DirSelectDialog: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var layout_dialog: UIView!
    @IBOutlet weak var layout_bg: UIView!
    @IBOutlet weak var tv_title: UILabel!
    @IBOutlet weak var btn_close: UIButton!
    
    @IBOutlet weak var table_dir: UITableView!
    @IBOutlet weak var table_dir_height: NSLayoutConstraint!
    
    var listener: onDirSelectDialogListener!
    
    var mDirList: [GalleryDir]!
    
    func _init(){
        self.frame.size.width = MyUtil.screenWidth
        self.frame.size.height = MyUtil.screenHeight
        
        layout_dialog.layer.cornerRadius = 2
        layout_bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_bg_tap(recognizer:))))
        
        if (mDirList.count > 4) {
            table_dir_height.constant = 312
        } else {
            table_dir_height.constant = CGFloat(48 * mDirList.count)
        }
        
        table_dir.dataSource = self
        table_dir.delegate = self
        
        table_dir.reloadData()
    }
    
    @objc private func layout_bg_tap(recognizer: UITapGestureRecognizer) {
        hideView()
    }
    
    func showView(){
        _init()
        self.isHidden = false
    }
    
    func hideView() {
        self.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mDirList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryDirCell")! as! GalleryDirCell
        let position = indexPath.row
        
        cell.tv_title.text = mDirList[position].title + " (" + String(mDirList[position].count) + ")"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position = indexPath.row
        
        listener.onDirSelect(position: position)
        hideView()
    }
    
}

protocol onDirSelectDialogListener {
    func onDirSelect(position: Int)
}
