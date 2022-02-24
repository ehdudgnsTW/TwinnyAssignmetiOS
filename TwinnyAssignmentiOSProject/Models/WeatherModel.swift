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
                
                //fb: 변수 선언 시 어노테이션이 WeatherModel.Response.Body.Items.WeatherDataModel로
                //길어지기 때문에 WeatherDataModel는 따로 분리하는 것을 권장합니다.
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
