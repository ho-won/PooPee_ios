//
//  CropImageController.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 8. 23..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

class CropImageController: BaseController, UIScrollViewDelegate {
    @IBOutlet weak var layout_scroll: UIView!
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var layout_content: UIView!
    
    @IBOutlet weak var iv_image: UIImageView!
    @IBOutlet weak var iv_image_top: NSLayoutConstraint!
    @IBOutlet weak var iv_image_bottom: NSLayoutConstraint!
    @IBOutlet weak var iv_image_trailing: NSLayoutConstraint!
    @IBOutlet weak var iv_image_leading: NSLayoutConstraint!
    
    @IBOutlet weak var layout_focus: UIView!
    @IBOutlet weak var layout_focus_height: NSLayoutConstraint!
    @IBOutlet weak var layout_focus_width: NSLayoutConstraint!
    
    var listener : onCropImageListener!
    
    var mImage: UIImage!
    let layout_focus_size: CGFloat = MyUtil.screenWidth - 20
    var left_space_size: CGFloat = 0
    var top_space_size: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroll_view.minimumZoomScale = 1.0
        scroll_view.maximumZoomScale = 6.0
        scroll_view.delegate = self
        
        _init()
        setListener()
    }
    
    func _init() {
        iv_image.image = mImage
        
        layout_focus_height.constant = layout_focus_size
        layout_focus_width.constant = layout_focus_size
        layout_focus.addBorders(edges: [.all], color: .white, inset: 0, thickness: 2)
        
        if (mImage.size.width > mImage.size.height) {
            let per = (layout_focus_size / mImage.size.width) * 100
            let imageHeight = (per / 100) * mImage.size.height

            top_space_size = (MyUtil.screenHeight - imageHeight) / 2
            left_space_size = (MyUtil.screenWidth - layout_focus_size) / 2
        } else if (mImage.size.width < mImage.size.height) {
            let per = (layout_focus_size / mImage.size.height) * 100
            let imageWidth = (per / 100) * mImage.size.width
            
            top_space_size = (MyUtil.screenHeight - layout_focus_size) / 2
            left_space_size = (MyUtil.screenWidth - imageWidth) / 2
        }
        
        iv_image_top.constant = top_space_size
        iv_image_bottom.constant = top_space_size
        iv_image_trailing.constant = left_space_size
        iv_image_leading.constant = left_space_size
    }
    
    func setListener() {
        
    }
    
    @IBAction func btn_confirm_click(_ sender: Any) {
        let image = self.screenshot(frame: CGRect(x: (self.view.frame.width / 2) - (layout_focus_size / 2), y: (self.view.frame.height / 2) - (layout_focus_size / 2), width: layout_focus_size, height: layout_focus_size))
        
        if (image != nil) {
            listener.resultCropImage(image: image!)
        }
        finish()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let sizeTop = top_space_size / scroll_view.zoomScale
        iv_image_top.constant = sizeTop
        iv_image_bottom.constant = sizeTop
        
        let sizeLeft = left_space_size / scroll_view.zoomScale
        iv_image_trailing.constant = sizeLeft
        iv_image_leading.constant = sizeLeft
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return layout_content
    }
    
    func screenshot(frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layout_scroll.layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}

protocol onCropImageListener {
    func resultCropImage(image : UIImage)
}
