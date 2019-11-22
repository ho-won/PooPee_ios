//
//  NoticeController.swift
//  PooPee_ios
//
//  Created by ho1 on 07/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire

class NoticeController: BaseController {
    @IBOutlet var root_view: UIView!
    
    @IBOutlet var tv_toolbar_title: UIButton!
    
    @IBOutlet var table_view: UITableView!
    
    var mNoticeList: [Notice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        
        tv_toolbar_title.setTitle("nav_text_02".localized, for: .normal)
        
        table_view.register(UINib(nibName: "NoticeCell", bundle: nil), forCellReuseIdentifier: "NoticeCell")
        table_view.dataSource = self
        table_view.delegate = self
        
        _init()
        setListener()
    }
    
    func _init() {
        taskNoticeList()
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        
    }
    
    /**
     * [GET] 공지사항목록
     */
    func taskNoticeList() {
        showLoading()
        var params: Parameters = Parameters()
        params.put("", "")
        
        BaseTask().request(url: NetDefine.NOTICE_LIST, method: .get, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
                    self.mNoticeList = []
                    let jsonArray = it.getJSONArray("notices")
                    
                    for i in 0 ..< jsonArray.count {
                        let jsonObject = jsonArray.getJSONObject(i)
                        let notice = Notice()
                        notice.notice_id = jsonObject.getString("notice_id")
                        notice.title = jsonObject.getString("title")
                        notice.content = jsonObject.getString("content")
                        notice.created = jsonObject.getString("created")
                        notice.openCheck = i == 0
                        
                        self.mNoticeList.append(notice)
                    }
                    
                    self.table_view.reloadData()
                }
                self.hideLoading()
        }
            , onFailed: { statusCode in
                self.hideLoading()
        })
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}

extension NoticeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mNoticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell")! as! NoticeCell
        
        cell.tv_title.text = mNoticeList[position].title
        cell.tv_date.text = StrManager.getDateTime(str: mNoticeList[position].created)
        
        cell.tv_content.convertHtml(htmlStr: mNoticeList[position].content)
        
        if (mNoticeList[position].openCheck) {
            cell.layout_content.setVisibility(gone: false, dimen: 0, attribute: .height)
        } else {
            cell.layout_content.setVisibility(gone: true, dimen: 0, attribute: .height)
        }
        
        cell.cb_detail.setSelected(selected: mNoticeList[position].openCheck)
        
        setListener(cell: cell, position: position)
        return cell
    }
    
    func setListener(cell: NoticeCell, position: Int) {
        cell.root_view.setOnClickListener {
            LogManager.e("test root_view")
            cell.cb_detail.setSelected(selected: !cell.cb_detail.isSelected)
            if (cell.cb_detail.isSelected) {
                cell.layout_content.setVisibility(gone: false, dimen: 0, attribute: .height)
                self.mNoticeList[position].openCheck = true
            } else {
                cell.layout_content.setVisibility(gone: true, dimen: 0, attribute: .height)
                self.mNoticeList[position].openCheck = false
            }
            self.table_view.reloadData()
        }
    }
    
}
