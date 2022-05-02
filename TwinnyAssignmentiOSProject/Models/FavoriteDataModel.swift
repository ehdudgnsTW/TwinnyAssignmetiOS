//
//  FavoriteDataModel.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import Foundation
import UIKit

struct FavoriteDataModel: Codable {
    var currentTemperature: Float
    var maxTemperature: Float
    var minTemperature: Float
    let cityId: String
    var isFavorite: Bool
    let cityName: String
    let locationCoordinate: CGPoint
    var skyState: String
}
