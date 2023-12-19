//
//  ToiletSearchController.swift
//  PooPee_ios
//
//  Created by ho1 on 2020/10/15.
//  Copyright © 2020 ho1. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMobileAds

class ToiletSearchController: BaseController {
    static let RESULT_CREATE = 1001
    
    @IBOutlet var btn_back: UIButton!
    @IBOutlet var edt_search: MyTextField!
    @IBOutlet var btn_delete: UIButton!
    @IBOutlet var btn_map: UIButton!
    
    @IBOutlet var tl_search: UITableView!
    @IBOutlet var layout_no_list: UIView!
    @IBOutlet var tv_no_list: UILabel!
    @IBOutlet var btn_bottom: UIButton!
    
    @IBOutlet var ad_view: AdView!
    @IBOutlet var ad_view_height: NSLayoutConstraint!

    private var mKeywordList: [KaKaoKeyword] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        setupViewResizerOnKeyboardShown()
        hideKeyboardWhenTappedAround()
        
        tl_search.register(UINib(nibName: "KakaoKeywordCell", bundle: nil), forCellReuseIdentifier: "KakaoKeywordCell")
        tl_search.dataSource = self
        tl_search.delegate = self
        
        edt_search.setHint(hint: "toilet_create_text_14".localized, color: colors.main_hint)
        tv_no_list.text = "toilet_create_text_01".localized
        
        btn_bottom.setTitle("toilet_create_text_02".localized, for: .normal)
        
        ad_view.loadBannerAd()
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        btn_back.setOnClickListener {
            self.finish()
        }
        btn_delete.setOnClickListener {
            self.edt_search.text = ""
        }
        btn_map.setOnClickListener {
            let controller = ObserverManager.getController(name: "ToiletCreateController")
            controller.segueData.requestCode = ToiletSearchController.RESULT_CREATE
            ObserverManager.root.startPresent(controller: controller)
        }
        btn_bottom.setOnClickListener {
            let controller = ObserverManager.getController(name: "ToiletCreateController")
            controller.segueData.requestCode = ToiletSearchController.RESULT_CREATE
            ObserverManager.root.startPresent(controller: controller)
        }
        edt_search.addTextChangedListener {
            if (self.edt_search.text!.count == 0) {
                self.tl_search.isHidden = true
                self.layout_no_list.isHidden = false
                self.btn_delete.isHidden = true
                self.btn_map.isHidden = false
            } else {
                self.tl_search.isHidden = false
                self.layout_no_list.isHidden = true
                self.btn_delete.isHidden = false
                self.btn_map.isHidden = true
                self.taskKakaoLocalSearch(query: self.edt_search.text!)
            }
        }
    }
    
    /**
     * [GET] 카카오지도 키워드 검색
     */
    func taskKakaoLocalSearch(query: String) {
        var params: Parameters = Parameters()
        params.put("query", query) // 검색을 원하는 질의어
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK " + NetDefine.KAKAO_API_KEY,
        ]
        
        BaseTask().request(url: NetDefine.KAKAO_LOCAL_SEARCH, method: .post, params: params, headers: headers, fullUrl: true
            , onSuccess: { response in
                self.mKeywordList = []
                let jsonArray = response.getJSONArray("documents")

                for i in 0 ..< jsonArray.count {
                    let jsonObject = jsonArray.getJSONObject(i)
                    let keyword = KaKaoKeyword()
                    keyword.address_name = jsonObject.getString("address_name")
                    keyword.place_name = jsonObject.getString("place_name")
                    keyword.latitude = jsonObject.getDouble("y")
                    keyword.longitude = jsonObject.getDouble("x")

                    self.mKeywordList.append(keyword)
                }

                self.tl_search.reloadData()
        }
            , onFailed: { statusCode in
                
        })
    }
    
    override func onControllerResult(requestCode: Int, data: SegueData) {
        if (requestCode == ToiletSearchController.RESULT_CREATE) {
            getParentController().view.makeToast(message: "toilet_create_text_13".localized)
            finish()
        }
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}

extension ToiletSearchController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mKeywordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoKeywordCell")! as! KakaoKeywordCell
        let position = indexPath.row
        
        cell.tv_title.text = mKeywordList[position].place_name
        cell.tv_sub.text = mKeywordList[position].address_name
        
        cell.setOnClickListener {
            let controller = ObserverManager.getController(name: "ToiletCreateController")
            controller.segueData.putExtra(key: ToiletCreateController.KAKAO_KEYWORD, data: self.mKeywordList[position])
            controller.segueData.requestCode = ToiletSearchController.RESULT_CREATE
            ObserverManager.root.startPresent(controller: controller)
        }
        
        return cell
    }
    
}
