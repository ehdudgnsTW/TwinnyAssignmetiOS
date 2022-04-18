//
//  ImageToRight.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit

extension UIButton {
    func imageSetting(status: Bool) {
        if status {
            self.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_yellow"), 20, 20), for: .normal)
        }
        else {
            self.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_black"), 20, 20), for: .normal)
        }
    }
    
    func imageMoveRight() {
        self.contentHorizontalAlignment = .left
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func imageToRight() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
}

