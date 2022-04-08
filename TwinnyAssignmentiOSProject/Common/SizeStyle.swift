//
//  ImageReSize.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit

struct SizeStyle {
    static func resizeImage(image: UIImage?, _ width: CGFloat, _ height: CGFloat) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x:0, y:0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
            
    }
}
