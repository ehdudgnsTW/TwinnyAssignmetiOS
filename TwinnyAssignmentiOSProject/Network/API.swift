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
    
    //fb: 매개변수의 속성에 따라 타입을 맞춰주는 것을 권장합니다.
    //ex) nx, ny -> CGPoint 유형 / date, time -> Date 유형
    func getData(nx: String, ny: String,baseTime: String, baseDate: String,currentTime: String) {
        //fb: 사용 방법을 볼 때, urlString은 지역변수로 선언하여 사용하는 것을 권장합니다.
        //다른 유형의 정보를 가져와야 한다면 urlString은 얼마든지 바뀔 수 있습니다.
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
                    //fb: 오류 발생 시 무시하는 것 보다 파악하는 것이 좋습니다. (ex. 로그 기록)
                    if let decodeData = try? decoder.decode(WeatherModel.self, from: data) {
                        //fb: 빈 문자열이 아닌 옵셔널을 사용하는 것을 권장합니다.
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
                                //fb: 정보를 배열로 저장하면 어떤 목적과 용도인지 알 수 없습니다.  데이터 모델 사용을 권장합니다.
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
