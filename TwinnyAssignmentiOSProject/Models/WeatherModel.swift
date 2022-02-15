//
//  WeatherModel.swift
//  TwinnyAssignmentiOSProject
//
//  Created by 도영훈 on 2022/02/13.
//

import Foundation

class DataModel: NSObject {
    var maxTemp: String
    var minTemp: String
    var temp: String
    var locationName: String
    
    init(locationName: String,max: String, min: String, temp: String) {
        self.maxTemp = max
        self.minTemp = min
        self.temp = temp
        self.locationName = locationName
    }
}

struct WeatherModel: Codable {
    var response: Response
    
    struct Response: Codable {
        var body: Body
        
        struct Body: Codable {
            var items: Items
            
            struct Items: Codable {
                var item: [WeatherDataModel]
                
                struct WeatherDataModel: Codable {
                    var category: String
                    var fcstValue: String
                    var baseDate: String
                    var baseTime: String
                }
            }
        }
    }
}
