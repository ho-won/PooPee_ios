//
//  MyAnimation.swift
//  base_ios
//
//  Created by Jung ho Seo on 2018. 11. 8..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import UIKit

func setAniFadeIn(view: UIView) {
    view.alpha = 0
    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
        view.alpha = 1
    }, completion: {_ in
        view.isHidden = false
    })
}

/**
 * cell animation
 */
func setAniCell(cell: UITableViewCell) {
    let perY = (cell.frame.height * 20) / 100
    cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
    cell.frame.origin.y = cell.frame.origin.y - perY
    cell.alpha = 0
    UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
        cell.transform = CGAffineTransform.identity
        cell.frame.origin.y = cell.frame.origin.y + perY
        cell.alpha = 1
    }, completion: nil)
}
