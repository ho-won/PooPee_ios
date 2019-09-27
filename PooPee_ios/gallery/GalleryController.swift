//
//  GalleryController.swift
//  CarTrader
//
//  Created by Jung ho Seo on 2018. 5. 17..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import UIKit
import Photos

class GalleryController: BaseController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, onDirSelectDialogListener, onCropImageListener {
    let IMAGE_WIDTH = (MyUtil.screenWidth - 4) / 3
    
    @IBOutlet weak var layout_category: UIView!
    @IBOutlet weak var tv_category: UILabel!
    @IBOutlet weak var btn_camera: UIButton!
    
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var layout_bottom: UIView!
    @IBOutlet weak var layout_bottom_height: NSLayoutConstraint!
    @IBOutlet weak var tv_count: UILabel!
    @IBOutlet var view_dir_select_dialog: DirSelectDialog!
    
    var listener : onGalleryListener!
    
    var mDirList: [GalleryDir] = [] // 디렉토리목록
    var mPhotoList: PHFetchResult<PHAsset> = PHFetchResult() // 이미지목록
    var mSelectList: Array<Int> = Array() // 이미지목록에서 선택한 이미지의 position 목록
    var mMultiSelectSize = 10 // 이미지 최대 선택 가능 수
    var mCropImage = false // 크롭이미지 체크
    
    let imageManager = PHImageManager.default()
    let requestOptions = PHImageRequestOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.main_content_background)
        
        layout_category.layer.borderWidth = 1
        layout_category.layer.borderColor = UIColor(hex: "#3F526A")?.cgColor
        layout_category.layer.cornerRadius = 4
        layout_category.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(layout_category_tap(recognizer:))))
        
        collection_view.delegate = self
        collection_view.dataSource = self
        
        let ic_image_camera = UIImage(named: "ic_albumlist_camera_normal_96")?.withRenderingMode(.alwaysTemplate)
        btn_camera.setImage(ic_image_camera, for: .normal)
        btn_camera.tintColor = UIColor(hex: "#3F526A")
        
        layout_bottom.addBorders(edges: [.bottom], color: UIColor(hex: "#F1F1F1")!, inset: 0, thickness: 1)
        layout_bottom.isHidden = true
        layout_bottom_height.constant = 0
        tv_count.backgroundColor = UIColor(hex: "#3F526A")
        tv_count.cornerRadius(corner: [.allCorners], radius: 12)
        
        
        view.addSubview(view_dir_select_dialog)
        view_dir_select_dialog.listener = self
        
        _init()
    }
    
    func _init() {
        setDir()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc private func layout_category_tap(recognizer: UITapGestureRecognizer) {
        if (mDirList.count > 0) {
            view_dir_select_dialog.mDirList = mDirList
            view_dir_select_dialog.showView()
        }
    }
    
    @IBAction func btn_camera_click(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            startCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        //access allowed
                        self.startCamera()
                    } else {
                        //access denied
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func btn_send_click(_ sender: Any) {
        showLoading()
        
        DispatchQueue.main.async {
            var selectImageList : Array<UIImage> = Array()
            
            var count = 0
            for position in self.mSelectList {
                var imageWidth = self.mPhotoList[position].pixelWidth
                var imageHeight = self.mPhotoList[position].pixelHeight
                
                while imageWidth > 1024 {
                    imageWidth = Int(Double(imageWidth) / 1.1)
                    imageHeight = Int(Double(imageHeight) / 1.1)
                }
                
                // targetSize: PHImageManagerMaximumSize CGSize(width: 100, height: 100)
                self.requestOptions.isNetworkAccessAllowed = true
                self.imageManager.requestImage(for: self.mPhotoList.object(at: position), targetSize: CGSize(width: imageWidth, height: imageHeight), contentMode: .aspectFill, options: self.requestOptions, resultHandler: { (image, error) in
                    selectImageList.append(image!)
                    count += 1
                    
                    if (count == self.mSelectList.count) {
                        if (self.mCropImage) {
                            self.hideLoading()
                            let controller = ObserverManager.getController(name: "CropImageController") as! CropImageController
                            controller.listener = self
                            controller.mImage = selectImageList[0]
                            self.startPresent(controller: controller)
                        } else {
                            self.finish()
                            self.listener?.resultGallery(images: selectImageList)
                        }
                    }
                })
            }
        }
    }
    
    /**
     * 폴더선택팝업 콜백
     */
    func onDirSelect(position: Int) {
        setPotos(position: position)
    }
    
    func startCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /*
     * 카메라 결과
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        DispatchQueue.main.async {
            var images : Array<UIImage> = Array()
            let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
            
            var imageWidth = Int(image.size.width)
            var imageHeight = Int(image.size.height)
            
            while imageWidth > 1024 {
                imageWidth = Int(Double(imageWidth) / 1.1)
                imageHeight = Int(Double(imageHeight) / 1.1)
            }
            
            images.append(self.resizeImage(image: image, targetSize: CGSize(width: imageWidth, height: imageHeight)))
            picker.dismiss(animated: true, completion: {
                if (self.mCropImage) {
                    let controller = ObserverManager.getController(name: "CropImageController") as! CropImageController
                    controller.listener = self
                    controller.mImage = images[0]
                    self.startPresent(controller: controller)
                } else {
                    self.finish()
                    self.listener?.resultGallery(images: images)
                }
            })
        }
    }
    
    func setDir() {
        mDirList = []
        mSelectList = []
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        for i in 0 ..< smartAlbums.count{
            let collection = smartAlbums[i]
            let title : String = collection.localizedTitle!
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            let result = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            
            if (result.count > 0) {
                let galleryDir = GalleryDir()
                galleryDir.collection = collection
                galleryDir.title = title
                galleryDir.count = result.count
                mDirList.append(galleryDir)
            }
        }
        
        for i in 0 ..< albums.count{
            let collection = albums[i]
            let title : String = collection.localizedTitle!
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            let result = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            
            if (result.count > 0) {
                let galleryDir = GalleryDir()
                galleryDir.collection = collection
                galleryDir.title = title
                galleryDir.count = result.count
                mDirList.append(galleryDir)
            }
        }
        
        var allPhotoPosition = 0
        for i in 0 ..< mDirList.count {
            if (mDirList[i].count > mDirList[allPhotoPosition].count) {
                allPhotoPosition = i
            }
        }
        
        if (mDirList.count > 0) {
            setPotos(position: allPhotoPosition)
        } else {
            view.makeToast(message: "No photos available")
        }
    }
    
    func setPotos(position: Int) {
        tv_count.text = ""
        layout_bottom.isHidden = true
        layout_bottom_height.constant = 0
        mPhotoList = PHFetchResult()
        mSelectList = []
        
        DispatchQueue.global(qos: .background).async {
            self.requestOptions.isSynchronous = true
            self.requestOptions.resizeMode = .exact
            self.requestOptions.deliveryMode = .highQualityFormat
            self.requestOptions.normalizedCropRect = CGRect(x: 0, y: 0, width: 150, height: 150)
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.mPhotoList = PHAsset.fetchAssets(in: self.mDirList[position].collection, options: fetchOptions)
            
            DispatchQueue.main.async {
                self.tv_category.text = self.mDirList[position].title
                self.collection_view.reloadData()
            }
        }
        
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale)//(size * retinaScale, size * retinaScale)
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x:0, y: 0,width: CGFloat(cropSizeLength),height: CGFloat(cropSizeLength))
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.normalizedCropRect = cropRect
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mPhotoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        let position = indexPath.row
        
        imageManager.requestImage(for: self.mPhotoList.object(at: position), targetSize: CGSize(width:150, height: 150), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
            if (image != nil) {
                cell.setImage(image: image!)
            }
        })
        
        if (mSelectList.contains(position)) {
            cell.tv_index.text = String(mSelectList.firstIndex(of: position)! + 1)
            cell.layout_select.isHidden = false
        } else {
            cell.layout_select.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: IMAGE_WIDTH, height: IMAGE_WIDTH)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let position = indexPath.row
        
        if (mMultiSelectSize > 1) {
            if (mSelectList.contains(position)) {
                let index = mSelectList.firstIndex(of: position)
                mSelectList.remove(at: index!)
            } else {
                if (mSelectList.count < mMultiSelectSize) {
                    mSelectList.append(position)
                }
            }
        } else {
            mSelectList = Array()
            mSelectList.append(position)
        }
        
        collection_view.reloadData()
        
        if (mSelectList.count > 0) {
            tv_count.text = String(mSelectList.count)
            layout_bottom.isHidden = false
            layout_bottom_height.constant = 50
        } else {
            tv_count.text = ""
            layout_bottom.isHidden = true
            layout_bottom_height.constant = 0
        }
    }
    
    func resultCropImage(image: UIImage) {
        DispatchQueue.main.async {
            var images: [UIImage] = []
            images.append(image)
            self.dismiss(animated: false, completion: {
                self.listener?.resultGallery(images: images)
            })
        }
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.finish()
    }
    
}

protocol onGalleryListener {
    func resultGallery(images : Array<UIImage>)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
