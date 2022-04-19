//
//  Repository.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/14.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    var totalData: [FavoriteDataModel] { get set }
    func getTotalData() -> Observable<[FavoriteDataModel]>
    func changeTotalData(totoalData: [FavoriteDataModel])
}

final class Repository: RepositoryProtocol {
    
    var totalData: [FavoriteDataModel] = []
    
    func changeTotalData(totoalData: [FavoriteDataModel]) {
        
    }
    
    func getTotalData() -> Observable<[FavoriteDataModel]> {
        return .just(totalData)
    }
}

final class MockRepository: RepositoryProtocol {
    
    var totalData: [FavoriteDataModel] = []
    
    func changeTotalData(totoalData: [FavoriteDataModel]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try? encoder.encode(totoalData)
        if let data = jsonData, let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentDirectory.appendingPathComponent("citys")
            do {
                try data.write(to: path)
            } catch {
                print("error")
            }
        }
    }
    
    func getTotalData() -> Observable<[FavoriteDataModel]> {
        let decoder = JSONDecoder()
        if let documenDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documenDirectory.appendingPathComponent("citys")
            if FileManager.default.fileExists(atPath: path.path) {
                if let data = try? Data(contentsOf: path), let tmpData = try? decoder.decode([FavoriteDataModel].self, from: data) {
                    self.totalData = tmpData                }
            }
            else {
                let currentTemperature: [Float] = [12,16,18,10,14,13,11,20]
                let maxTemperature: [Float] = [32,24,20,21,23]
                let minTemperature: [Float] = [10,9,8,7,6,5]
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                let csvPath = Bundle.main.path(forResource: "기상청41_단기예보-조회서비스_오픈API활용가이드_격자_위경도_20210401_", ofType: "csv")!
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: csvPath))
                    let dataEncoded = String(data: data, encoding: .utf8)
                    if let dataArr = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: "\",\"")}) {
                        for cityData in dataArr {
                            if cityData.count > 1, cityData[0].contains("kor") {
                                if cityData[3] != "", cityData[4] != "" {
                                    let cityName = "\(cityData[2]) \(cityData[3]) \(cityData[4])"
                                    if let x = Int(cityData[5]),let y = Int(cityData[6]) {
                                        totalData.append(FavoriteDataModel(currentTemperature: currentTemperature[Int.random(in: 0..<currentTemperature.count)],
                                                                 maxTemperature: maxTemperature[Int.random(in: 0..<maxTemperature.count)],
                                                                 minTemperature: minTemperature[Int.random(in: 0..<minTemperature.count)] ,
                                                                 cityId: cityData[1],
                                                                 isFavorite: false,
                                                                 cityName: cityName,
                                                                 locationCoordinate: CGPoint(x: x, y: y)))
                                    }

                                }
                            }
                        }
                    }
                    let jsonData = try? encoder.encode(self.totalData)
                    if let data = jsonData {
                        try data.write(to: path)
                    }
                } catch {
                    print("csvfile read error")
                }
            }
        }
        return .just(totalData)
    }
    
    
}
        
