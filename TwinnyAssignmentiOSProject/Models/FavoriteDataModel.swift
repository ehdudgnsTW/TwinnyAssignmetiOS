//
//  FavoriteDataModel.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import Foundation

struct FavoriteDataModel {
    var avgTemperature: Float
    let maxTemperature: Float
    let minTemperature: Float
    var isFavorite: Bool
    let index: Int
    let cityName: String
    
    init() {
        self.avgTemperature = 100
        self.maxTemperature = 100
        self.minTemperature = 100
        self.isFavorite = false
        self.cityName = ""
        self.index = -1
    }
    
    init(avgTemperature: Float, maxTemperature: Float, minTemperature: Float, isFavorite: Bool, cityName: String, index: Int) {
        self.avgTemperature = avgTemperature
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.isFavorite = isFavorite
        self.index = index
        self.cityName = cityName
    }
}
