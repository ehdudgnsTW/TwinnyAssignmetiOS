//
//  WeatherLabel.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/28.
//

import Foundation
import UIKit

extension UILabel {
    func setWeatherStateText(state: String) {
        self.textAlignment = .center
        switch state {
        case "맑음":
            setTextFontWeightColor("날이 좋아서..", font: 20, weight: .medium, UIColor.darkGray)
        case "구름조금":
            setTextFontWeightColor("날이 적당해서..", font: 20, weight: .medium, UIColor.darkGray)
        default:
            setTextFontWeightColor("날이 좋지 않아서..", font: 20, weight: .medium, UIColor.darkGray)
        }
    }
}
