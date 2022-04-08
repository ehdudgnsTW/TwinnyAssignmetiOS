//
//  Label+Context+Font+Weight.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit

extension UILabel {
    func setTextFontWeightColor(_ txt: String?, font: CGFloat, weight: UIFont.Weight, _ color: UIColor?) {
        if let txt = txt {
            self.text = txt
        }
        self.font = .systemFont(ofSize: font, weight: weight)
        if let color = color {
            self.textColor = color
        }
        else {
            self.textColor = .black
        }
    }
}
