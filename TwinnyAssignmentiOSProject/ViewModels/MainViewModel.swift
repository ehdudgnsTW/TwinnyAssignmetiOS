//
//  MainViewModel.swift
//  TwinnyAssignmentiOSProject
//
//  Created by 도영훈 on 2022/02/10.
//

import Foundation

class MainViewModel: NSObject {
    
    private var locationData: [[String]] = []
    private let baseTime = ["0200", "0500", "0800", "1100", "1400", "1700", "2000", "2300"]
    private var tmpLocationData: [String] = []
    var favoriteData: [String] = []
    var repository = API()

    
    func getTime(now: String) -> String {
        for i in (0..<baseTime.count) {
            if now <= baseTime[i] {
                return baseTime[i-1]
            }
        }
        return "0200"
    }
    
    func getData(location: String, baseTime: String, baseDate: String) {
        for i in locationData {
            if i[0] == location {
                let transbaseTime = getTime(now: baseTime)
                repository.getData(nx: i[4], ny: i[5], baseTime: transbaseTime, baseDate: baseDate,currentTime: baseTime)
            }
        }
    }
    
    func getCSVFile() {
        
        let path = Bundle.main.path(forResource: "기상청41_단기예보-조회서비스_오픈API활용가이드_격자_위경도_20210401_", ofType: "csv")
        if let content = try? String(contentsOfFile: path!) {
            let data  = content.components(separatedBy: "\n")
            data.map {
                tmp in
                var temp = tmp.components(separatedBy: "\",\"")
                if temp.count > 1 {
                    //fb: temp[2]...가 어떤 값을 의미하는 지 알 수 없습니다.
                    locationData.append(["\(temp[2]) \(temp[3]) \(temp[4])",temp[2],temp[3],temp[4],temp[5],temp[6]])
                }
            }
        }
        for i in (0..<locationData.count) {
            tmpLocationData.append(locationData[i][0])
        }
    }
    
    func findData(location: String) -> [String] {
        var res: [String] = []
        for i in tmpLocationData {
            if i.contains(location){
                res.append(i)
            }
        }
        return res
//        print(tmpLocationData)
    }
}
