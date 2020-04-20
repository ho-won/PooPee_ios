//
//  ToiletController.swift
//  PooPee_ios
//
//  Created by ho1 on 08/10/2019.
//  Copyright © 2019 ho1. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class ToiletController: BaseController, MFMessageComposeViewControllerDelegate {
    static let TOILET = "toilet"
    
    @IBOutlet var tv_toolbar_title: UIButton!
    @IBOutlet var tv_like: UILabel!
    @IBOutlet var tv_like_count: UILabel!
    
    @IBOutlet var table_view: UITableView!
    
    @IBOutlet var layout_sms: bg_sms!
    @IBOutlet var tv_sms: UILabel!
    
    private var mToilet: Toilet = Toilet()
    private var mCommentList: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        
        table_view.register(UINib(nibName: "ToiletHeaderCell", bundle: nil), forCellReuseIdentifier: "ToiletHeaderCell")
        table_view.register(UINib(nibName: "ToiletCommentCell", bundle: nil), forCellReuseIdentifier: "ToiletCommentCell")
        table_view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 0)
        
        tv_like.text = "home_text_04".localized
        tv_sms.text = "home_text_13".localized
        
        _init()
        setListener()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        if (!isViewDidAppear) {
            print("ToiletController_viewDidAppear")
            isViewDidAppear = true
            refresh()
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        print("ToiletController_viewDidDisappear")
        isViewDidAppear = false
    }
    
    func _init() {
        mToilet = segueData.getExtra(key: ToiletController.TOILET) as! Toilet
        ObserverManager.currentToilet = mToilet
        tv_toolbar_title.setTitle(mToilet.name, for: .normal)
        
        table_view.dataSource = self
        table_view.delegate = self
    }
    
    func refresh() {
        taskCommentList()
    }
    
    func setListener() {
        layout_sms.setOnClickListener {
            let dialog = ShareDialog()
            dialog.setAction(ShareDialog.ACTION_SHARE)
            dialog.setToilet(self.mToilet)
            dialog.refresh()
            dialog.show(view: ObserverManager.root.view)
        }
    }
    
    /**
     * [GET] 댓글목록
     */
    func taskCommentList() {
        showLoading()
        var params: Parameters = Parameters()
        params.put("member_id", SharedManager.instance.getMemberId())
        params.put("toilet_id", mToilet.toilet_id)
        
        BaseTask().request(url: NetDefine.COMMENT_LIST, method: .get, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
                    self.tv_like_count.text = it.getString("like_count")
                    self.mToilet.like_check = it.getString("like_check") == "1"
                    self.mToilet.comment_count = it.getString("comment_count")
                    
                    let jsonArray = it.getJSONArray("comments")
                    self.mCommentList = []
                    self.mCommentList.append(Comment())
                    
                    for i in 0 ..< jsonArray.count {
                        let jsonObject = jsonArray.getJSONObject(i)
                        let comment = Comment()
                        comment.comment_id = jsonObject.getString("comment_id")
                        comment.member_id = jsonObject.getString("member_id")
                        comment.gender = jsonObject.getString("gender")
                        comment.name = jsonObject.getString("name")
                        comment.content = jsonObject.getString("content")
                        comment.created = jsonObject.getString("created")
                        comment.view_type = Toilet.VIEW_COMMENT
                        
                        self.mCommentList.append(comment)
                    }
                    
                    self.table_view.reloadData()
                }
                self.hideLoading()
        }
            , onFailed: { statusCode in
                self.hideLoading()
        })
    }
    
    /**
     * [POST] 좋아요
     */
    func taskToiletLike() {
        var params: Parameters = Parameters()
        params.put("member_id", SharedManager.instance.getMemberId())
        params.put("toilet_id", mToilet.toilet_id)
        
        BaseTask().request(url: NetDefine.TOILET_LIKE, method: .post, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
                    self.tv_like_count.text = it.getString("like_count")
                    self.mToilet.like_check = it.getString("like_check") == "1"
                    self.table_view.reloadData()
                }
        }
            , onFailed: { statusCode in
                
        })
    }
    
    /**
     * [POST] 댓글작성
     */
    func taskCommentCreate(comment: String) {
        showLoading()
        var params: Parameters = Parameters()
        params.put("member_id", SharedManager.instance.getMemberId())
        params.put("toilet_id", mToilet.toilet_id)
        params.put("content", comment)
        
        BaseTask().request(url: NetDefine.COMMENT_CREATE, method: .post, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
                    self.taskCommentList()
                }
                self.hideLoading()
        }
            , onFailed: { statusCode in
                self.hideLoading()
        })
    }
    
    /**
     * [DELETE] 댓글삭제
     */
    func taskCommentDelete(comment: Comment, position: Int) {
        showLoading()
        var params: Parameters = Parameters()
        params.put("member_id", SharedManager.instance.getMemberId())
        params.put("comment_id", comment.comment_id)
        
        BaseTask().request(url: NetDefine.COMMENT_DELETE, method: .delete, params: params
            , onSuccess: { it in
                if (it.getInt("rst_code") == 0) {
//                    let indexPath = IndexPath(item: position, section: 0)
//                    self.mCommentList.remove(at: indexPath.row)
//                    self.table_view.deleteRows(at: [indexPath], with: .automatic)
                    self.taskCommentList()
                    self.view.makeToast(message: "toast_delete_complete".localized)
                }
                self.hideLoading()
        }
            , onFailed: { statusCode in
                self.hideLoading()
        })
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}

extension ToiletController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let position = indexPath.row
        
        if (position == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToiletHeaderCell")! as! ToiletHeaderCell
            
            setListener(cell: cell, position: position)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToiletCommentCell")! as! ToiletCommentCell
            
            if (mCommentList[position].gender == "0") {
                cell.iv_gender.image = UIImage(named: "ic_man_profile")!
            } else {
                cell.iv_gender.image = UIImage(named: "ic_woman_profile")!
            }
            
            cell.tv_name.text = mCommentList[position].name
            cell.tv_date.text = StrManager.getDateTime(str: mCommentList[position].created)
            cell.tv_comment.text = mCommentList[position].content
            
            setListener(cell: cell, position: position)
            return cell
        }
    }
    
    func setListener(cell: ToiletHeaderCell, position: Int) {
        cell.map_view_click.setOnClickListener {
            self.finish()
        }
        cell.cb_tap_address.setOnClickListener {
            cell.cb_tap_address.setSelected(selected: !cell.cb_tap_address.isSelected)
            cell.layout_detail_address.setVisibility(gone: !cell.cb_tap_address.isSelected, dimen: 0, attribute: .height)
            self.table_view.reloadData()
        }
        cell.cb_tap_manager.setOnClickListener {
            cell.cb_tap_manager.setSelected(selected: !cell.cb_tap_manager.isSelected)
            cell.layout_detail_manager.setVisibility(gone: !cell.cb_tap_manager.isSelected, dimen: 0, attribute: .height)
            self.table_view.reloadData()
        }
        cell.btn_like.setOnClickListener {
            if (SharedManager.instance.isLoginCheck()) {
                self.taskToiletLike()
            } else {
                cell.btn_like.setSelected(selected: false)
                let controller = ObserverManager.getController(name: "LoginController")
                ObserverManager.root.startPresent(controller: controller)
            }
        }
        cell.tv_manager_tel.setOnClickListener {
            guard let number = URL(string: "tel://" + self.mToilet.manager_tel) else { return }
            UIApplication.shared.open(number, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
        cell.btn_comment.setOnClickListener {
            if (SharedManager.instance.isLoginCheck()) {
                let dialog = CommentCreateDialog(
                    onCommentCreate: { it in
                        self.taskCommentCreate(comment: it)
                })
                dialog.show(view: ObserverManager.root.view)
            } else {
                let controller = ObserverManager.getController(name: "LoginController")
                ObserverManager.root.startPresent(controller: controller)
            }
        }
    }
    
    func setListener(cell: ToiletCommentCell, position: Int) {
        cell.btn_menu.setOnClickListener {
            self.openMenu(v: cell.btn_menu, position: position)
        }
    }
    
    func openMenu(v: UIView, position: Int) {
        var menuItems: [MenuItem] = []
        if (mCommentList[position].member_id == SharedManager.instance.getMemberId()) {
            menuItems.append(MenuItem(id: 1, title: "delete".localized))
            menuItems.append(MenuItem(id: 2, title: "modified".localized))
        } else {
            menuItems.append(MenuItem(id: 3, title: "report".localized))
        }
        
        let popupMenu = PopupMenu(
            view: v,
            menuItems: menuItems,
            onMenuItemClick: { menuItem in
                if (menuItem.id == 1) {
                    let dialog = BasicDialog(
                        onLeftButton: {
                            self.taskCommentDelete(comment: self.mCommentList[position], position: position)
                    },
                        onRightButton: {
                            
                    })
                    dialog.setTextContent("home_text_06".localized)
                    dialog.setBtnLeft("confirm".localized)
                    dialog.setBtnRight("cancel".localized)
                    dialog.show(view: ObserverManager.root.view)
                } else if (menuItem.id == 2) {
                    let dialog = CommentUpdateDialog(
                        onUpdate: { comment in
                            self.mCommentList[position] = comment
                            
                            let indexPath = IndexPath(item: position, section: 0)
                            self.table_view.reloadRows(at: [indexPath], with: .none)
                        }
                    )
                    dialog.setComment(self.mCommentList[position])
                    dialog.show(view: ObserverManager.root.view)
                } else if (menuItem.id == 3) {
                    if (SharedManager.instance.isLoginCheck()) {
                        let dialog = CommentReportDialog()
                        dialog.setComment(self.mCommentList[position])
                        dialog.show(view: ObserverManager.root.view)
                    } else {
                        let controller = ObserverManager.getController(name: "LoginController")
                        ObserverManager.root.startPresent(controller: controller)
                    }
                }
        })
        popupMenu.show(view: ObserverManager.root.view)
    }
    
}
