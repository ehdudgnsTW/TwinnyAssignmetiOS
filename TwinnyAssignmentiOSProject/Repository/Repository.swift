//
//  Repository.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/08.
//

import Foundation
import Alamofire
import RxSwift

enum APPService {
    case updateTemperature(Float)
    case updateFavorite(Bool)
}

protocol RepositoryProtocol {
    var totalData: [FavoriteDataModel] { get set }
    func getTotalData() -> Observable<[FavoriteDataModel]>
    func getCSVFileToData() -> Observable<[FavoriteDataModel]>
}

final class Repository: RepositoryProtocol {
    var totalData: [FavoriteDataModel] = []
    
    func getCSVFileToData() -> Observable<[FavoriteDataModel]> {
        return .just(totalData)
    }
    
    func getTotalData() -> Observable<[FavoriteDataModel]> {
        return .just(totalData)
    }
    
    
}

final class MockRepository: RepositoryProtocol {
    let currentTemperature: [Float] = [12,16,18,10,14,13,11,20]
    let maxTemperature: [Float] = [32,24,20,21,23]
    let minTemperature: [Float] = [10,9,8,7,6,5]
    let favorite: [Bool] = [true, false]
    
    var totalData: [FavoriteDataModel] = []
    
    func getCSVFileToData() -> Observable<[FavoriteDataModel]>{
        var XYData: [String:[String]] = [:]
        let path = Bundle.main.path(forResource: "기상청41_단기예보-조회서비스_오픈API활용가이드_격자_위경도_20210401_", ofType: "csv")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({
                $0.components(separatedBy: "\",\"")
            }) {
                for i in 1..<dataArr.count-1 {
                    if dataArr[i][3] != "" && dataArr[i][4] != "" {
                        let tmpStr = "\(dataArr[i][2]) \(dataArr[i][3]) \(dataArr[i][4])"
                        XYData[tmpStr] = [dataArr[i][5],dataArr[i][6]]
                        totalData.append(FavoriteDataModel(
                            avgTemperature: currentTemperature[Int.random(in: 0..<currentTemperature.count-1)],
                            maxTemperature: maxTemperature[Int.random(in: 0..<maxTemperature.count-1)],
                            minTemperature: minTemperature[Int.random(in: 0..<minTemperature.count-1)],
                            isFavorite: favorite[Int.random(in: 0...1)],
                            cityName: tmpStr,
                            index: i-1))
                    }
                }
                print(XYData)
                print(totalData)
            }
        } catch {
            print("reading csv file error")
        }
        return .just(totalData)
    }
    
    func getTotalData() -> Observable<[FavoriteDataModel]> {
        return .just(totalData)
    }
}
