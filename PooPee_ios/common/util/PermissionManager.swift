//
//  PermissionManager.swift
//  base_ios
//
//  Created by Jung ho Seo on 2019. 4. 5..
//  Copyright © 2019년 EMEYE. All rights reserved.
//

import Foundation
import Photos

class PermissionManager {
    
    static func startGallery(multiSelectSize: Int, listener: onGalleryListener!) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            let controller = ObserverManager.getController(name: "GalleryController") as! GalleryController
            controller.listener = listener
            controller.mMultiSelectSize = multiSelectSize
            ObserverManager.root.startPresent(controller: controller)
            break
        case .denied, .restricted:
            // as above
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        let controller = ObserverManager.getController(name: "GalleryController") as! GalleryController
                        controller.listener = listener
                        controller.mMultiSelectSize = multiSelectSize
                        ObserverManager.root.startPresent(controller: controller)
                    }
                    break
                case .denied, .restricted:
                    // as above
                    break
                case .notDetermined:
                    // won't happen but still
                    break
                default:
                    break
                }
            }
            break
        default:
            break
        }
    }
    
    static func startCamera(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = delegate
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                ObserverManager.root.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        //access allowed
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            let imagePicker = UIImagePickerController()
                            imagePicker.delegate = delegate
                            imagePicker.sourceType = .camera;
                            imagePicker.allowsEditing = false
                            ObserverManager.root.present(imagePicker, animated: true, completion: nil)
                        }
                    } else {
                        //access denied
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                ObserverManager.root.view.makeToast(message: "Please allow camera permissions")
                            })
                        }
                    }
                }
            })
        }
    }
    
}
