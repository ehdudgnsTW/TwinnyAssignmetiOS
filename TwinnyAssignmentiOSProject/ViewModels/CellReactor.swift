//
//  CellReactor.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/21.
//

import Foundation

struct CellReactor {
    var cityName: String
    var cityId: String
    var currentTemperature: String
    var isFavorite: Bool
    
    init(model: FavoriteDataModel) {
        self.cityName = model.cityName
        self.cityId = model.cityId
        self.currentTemperature = "\(model.currentTemperature)"
        self.isFavorite = model.isFavorite
    }
}
