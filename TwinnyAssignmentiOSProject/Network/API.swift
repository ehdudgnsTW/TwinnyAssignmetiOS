//
//  API.swift
//  TwinnyAssignmentiOSProject
//
//  Created by 도영훈 on 2022/02/12.
//

import Foundation

class temperature: NSObject {
    @objc dynamic var result: [String] = []
}

class API {
    private let serviceKey = "6Ol5B7BC37C7SV00VSqlM4oeqXsU1v07eqoXve2g5R21dGmrd4zv57ynEaXtwwLH3r5yMEeExEPrb4PvP%2F5%2Bng%3D%3D"
    private var urlString = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
    var dataResult = temperature()
    
    func getData(nx: String, ny: String,baseTime: String, baseDate: String,currentTime: String) {
        urlString =
        urlString+"?serviceKey="+serviceKey+"&numOfRows=809&pageNo=1&dataType=JSON&base_date=\(baseDate)&base_time=\(baseTime)&nx=\(nx)&ny=\(ny)"
        if let url = URL(string: urlString) {            URLSession.shared.dataTask(with: url) {
                data,res,err in
                if let error = err {
                    print(error)
                    return
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    if let decodeData = try? decoder.decode(WeatherModel.self, from: data) {
                        var temperature: String = ""
                        var maxVal: String = ""
                        var minVal: String = ""
                        var check:Bool = false
                        for i in (0..<decodeData.response.body.items.item.count) {
                            let data = decodeData.response.body.items.item[i]
                            if data.category == "TMP" {
                                if check == false {
                                    temperature = data.fcstValue
                                    check = true
                                }
                            }
                            if data.category == "TMX" {
                                maxVal = data.fcstValue
                            }
                            if data.category == "TMN" {
                                minVal = data.fcstValue
                            }
                            if temperature != "" && maxVal != "" && minVal != "" {
                                self.dataResult.result = [temperature,maxVal,minVal]
                                return
                            }
                        }
                    }
                    
                }
            }.resume()
        }
    
    }
}
