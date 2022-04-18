//
//  ImageToRight.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit

extension UIButton {
    
    func imageMoveRight() {
        self.contentHorizontalAlignment = .left
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func imageToRight() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
}

func imageSetting(_ button: UIButton,status: Bool) {
    if status {
        button.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_yellow"), 20, 20), for: .normal)
    }
    else {
        button.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_black"), 20, 20), for: .normal)
    }
}
