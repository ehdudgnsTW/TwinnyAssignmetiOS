//
//  ImageToRight.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit

extension UIButton {
    func favoriteStateStarImageSetting(status: Bool) {
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

extension UIImageView {
    func setSkyImage(state: String, _ width: CGFloat, _ height: CGFloat) {
        switch state {
        case "흐림":
            self.image = SizeStyle.resizeImage(image: UIImage(named: "cloudy"), width, height)
        case "구름조금":
            self.image = SizeStyle.resizeImage(image: UIImage(named: "little_cloud"), width, height)
        case "비":
            self.image = SizeStyle.resizeImage(image: UIImage(named: "rainy"), width, height)
        case "눈":
            self.image = SizeStyle.resizeImage(image: UIImage(named: "snow"), width, height)
        default:
            self.image = SizeStyle.resizeImage(image: UIImage(named: "sunny"), width, height)
        }
    }
}


