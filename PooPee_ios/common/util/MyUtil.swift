//
//  MyUtil.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 7..
//  Copyright © 2018년 EMEYE. All rights reserved.
//
import UIKit
import StoreKit

class MyUtil {
    
    /**
     * 스크린 가로 사이즈
     */
    static let screenWidth: CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    /**
     * 스크린 세로 사이즈
     */
    static let screenHeight: CGFloat = {
        return UIScreen.main.bounds.height
    }()
    
    /**
     * 이미지 URL 유효하도록 변경
     */
    static func getImageUrl(url: String) -> String {
        if (url.count > 0) {
            return url.replacingOccurrences(of: " ", with: "%20")
        } else {
            return "no_image"
        }
    }
    
    /*
     * download file url
     */
    static func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        return fileURL
    }
    
    /**
     * 텍스트 부분 스타일 (bold, color, size, bottom line)
     */
    static func attributedText(withString string: String, font: UIFont, boldString: [String] = [], lineString: [String] = [], colorString: [String] = [], color: UIColor = .black, sizeString: [String] = [], size: CGFloat = 0) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: [.font: font])
        
        // bold
        let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        for text in boldString {
            let range = (string as NSString).range(of: text)
            attributedString.addAttributes(boldFontAttribute, range: range)
        }
        
        // text color
        for text in colorString {
            let range = (string as NSString).range(of: text)
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        // text size
        let sizeFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size)]
        for text in sizeString {
            let range = (string as NSString).range(of: text)
            attributedString.addAttributes(sizeFontAttribute, range: range)
        }
        
        // bottom line
        let lineFontAttribute: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        for text in lineString {
            let range = (string as NSString).range(of: text)
            attributedString.addAttributes(lineFontAttribute, range: range)
        }
        
        return attributedString
    }
    
    /**
     * 폴더생성
     */
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent(folderName)
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
            
            return filePath
        } else {
            return nil
        }
    }
    
    /**
     * device 의 앱 알림상태확인
     */
    static func areNotificationsEnabled(completionHandler: @escaping (_ areNotificationsEnabled: Bool)->()) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                completionHandler(true)
                print("push:authorized")
            case .denied:
                completionHandler(false)
                print("push:denied")
            case .notDetermined:
                completionHandler(false)
                print("push:not determined, ask user for permission now")
            default:
                completionHandler(false)
            }
        })
    }
    
    /**
     * In-App Review
     */
    public static func startInAppReview() {
        SKStoreReviewController.requestReview()
    }
    
    public static func shareText(_ text: String) {
        var activityItems = [String]()
        activityItems.append(text)
        
        let activityControlle = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityControlle.popoverPresentationController?.sourceView = ObserverManager.root.view
        ObserverManager.root.present(activityControlle, animated: true, completion: nil)
    }

}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
