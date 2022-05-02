//
//  Repository.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/14.
//

import Foundation
import RxSwift
import Alamofire

protocol RepositoryProtocol {
    static var shared: RepositoryProtocol { get }
    func getData() -> Observable<[FavoriteDataModel]>
    func changeData(_ cityId: String)
    func upDateDetailData(model: FavoriteDataModel) -> Observable<FavoriteDataModel>
}

final class Repository: RepositoryProtocol {
    
    static var shared: RepositoryProtocol = Repository()
    private var totalData: [FavoriteDataModel] = []
    
    private init() {
        let currentTemperature: [Float] = [12,16,18,10,14,13,11,20]
        let maxTemperature: [Float] = [32,24,20,21,23]
        let minTemperature: [Float] = [10,9,8,7,6,5]
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = documentDirectory.appendingPathComponent("citys")
            if FileManager.default.fileExists(atPath: path.path), let data = try? Data(contentsOf: path), let decodingData = try? decoder.decode([FavoriteDataModel].self, from: data) {
                self.totalData = decodingData
            }
            else {
                encoder.outputFormatting = .prettyPrinted
                let csvPath = Bundle.main.path(forResource: "기상청41_단기예보-조회서비스_오픈API활용가이드_격자_위경도_20210401_", ofType: "csv")!
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: csvPath))
                    let dataEncoded = String(data: data, encoding: .utf8)
                    if let dataArr = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: "\",\"")}) {
                        for cityData in dataArr {
                            let isValid = cityData.count > 1 && cityData[0].contains("kor")
                            let isNotDetailAddress = cityData.count >= 5 && cityData[3] != "" && cityData[4] != ""
                            if isValid, isNotDetailAddress {
                                let cityName = "\(cityData[2]) \(cityData[3]) \(cityData[4])"
                                if let x = Int(cityData[5]), let y = Int(cityData[6]) {
                                    totalData.append(.init(
                                        currentTemperature: currentTemperature[Int.random(in: 0..<currentTemperature.count)],
                                        maxTemperature: maxTemperature[Int.random(in: 0..<maxTemperature.count)],
                                        minTemperature: minTemperature[Int.random(in: 0..<minTemperature.count)] ,
                                        cityId: cityData[1],
                                        isFavorite: false,
                                        cityName: cityName,
                                        locationCoordinate: CGPoint(x: x, y: y),
                                        skyState: "맑음")
                                    )
                                }
                            }
                        }
                    }
                    let jsonData = try? encoder.encode(self.totalData)
                    if let data = jsonData {
                        try data.write(to: path)
                    }
                } catch {
                    print("error")
                }
                
            }
        }
    }
    
    func getWeatherData(model: FavoriteDataModel, baseTime: String, categoryList: [String], pageNo: String, numOfRows: String) -> Observable<[String: Float]> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let currentDate = dateFormatter.string(from: Date())
        
        let parameters = ["numOfRows": numOfRows,"pageNo": pageNo,"dataType":"JSON","base_date": currentDate,"base_time": baseTime,"nx": Int(model.locationCoordinate.x).description,"ny": Int(model.locationCoordinate.y).description]
        return executeAPI(parameters, categoryList).retry()
    }
    
    func executeAPI(_ parameters: Parameters,_ currentTMP: [String]) -> Observable<[String: Float]> {
        return .create { observer in
            
            let decoder = JSONDecoder()
            let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=F%2Fp%2BG6%2BXHFejoIHeqNZqluWcWODVZgvMeciUutkASGGcECIWgl113GK4EnrMZGsMEcPVon5FqN9%2B%2Fi%2BNituvDg%3D%3D"
            
            var result = [String: Float]()
            
            AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).validate().response(completionHandler: {
                data in
                switch data.result{
                case .success(let data):
                    if let data = data {
                        if let decodingData = try? decoder.decode(ResponseData.self, from: data) {
                            let response = decodingData.response
                            if response.header.resultCode == "00",
                               let items = response.body?.items.item {
                                currentTMP.forEach { category in
                                    guard let item = items.first(where: { $0.category == category }) else { return }
                                    result[category] = Float(item.fcstValue)
                                }
                            }
                            else {
                                print(decodingData.response.header.resultMsg)
                            }
                        }
                    }
                case .failure(let error):
                    observer.onError(error)
                }
                let isCompleted = currentTMP.map { result[$0] != nil }.reduce(true, { $0 && $1 })
                if isCompleted {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            })
            
            return Disposables.create()
        }
    }
    
    private func encodingData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try? encoder.encode(totalData)
        if let data = jsonData, let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentDirectory.appendingPathComponent("citys")
            do {
                try data.write(to: path)
            } catch {
                print("write error!!")
            }
        }
    }
    
    func upDateDetailData(model: FavoriteDataModel) -> Observable<FavoriteDataModel> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH00"
        let currentTime = dateFormatter.string(from: Date())
        let baseTimes = ["0200","0500","0800","1100","1400","1700","2000","2300"]
        var baseTime = ""
        for i in 0..<baseTimes.count {
            if baseTimes[i] >= currentTime {
                baseTime = baseTimes[(i-1)<0 ? baseTimes.count-1 : i-1]
                break
            }
        }
        let pageNo = (Int(currentTime)!/100 - Int(baseTime)!/100).description
        
        return Observable.zip(
            getWeatherData(model: model, baseTime: baseTime, categoryList: ["PTY", "SKY", "TMP"], pageNo: pageNo, numOfRows: "12"),
            getWeatherData(model: model, baseTime: "0200", categoryList: ["TMX", "TMN"], pageNo: "1", numOfRows: "160")
        ).map { $0.merging($1, uniquingKeysWith: { $1 }) }
            .do(onNext: {
                let result = $0
                for i in 0..<self.totalData.count {
                    if model.cityId == self.totalData[i].cityId {
                        self.totalData[i].currentTemperature = result["TMP"] ?? self.totalData[i].currentTemperature
                        self.totalData[i].maxTemperature = result["TMX"] ?? self.totalData[i].maxTemperature
                        self.totalData[i].minTemperature = result["TMN"] ?? self.totalData[i].minTemperature
                        switch result["PTY"] {
                        case 0:
                            switch result["SKY"] {
                            case 0:
                                self.totalData[i].skyState = "맑음"
                            case 3:
                                self.totalData[i].skyState = "구름조금"
                            default:
                                self.totalData[i].skyState = "흐림"
                            }
                        case 3:
                            self.totalData[i].skyState = "눈"
                        default:
                            self.totalData[i].skyState = "비"
                        }
                    }
                }
                self.encodingData()
            }).map { _ in
                return self.totalData.first { $0.cityId == model.cityId } ?? model
            }
    }
    
    func getData() -> Observable<[FavoriteDataModel]> {
        return .just(totalData)
    }
    
    func changeData(_ cityId: String) {
        for i in 0..<totalData.count {
            if cityId == totalData[i].cityId {
                totalData[i].isFavorite.toggle()
            }
        }
        encodingData()
    }
    
}

final class MockRepository: RepositoryProtocol {

    static var shared: RepositoryProtocol = MockRepository()
    private var totalData: [FavoriteDataModel] = []
    let publishSubject = PublishSubject<[String:Float]>()
    let detailDataSubject = PublishSubject<FavoriteDataModel>()
    private var result: [String:Float] = [:]
    
    private init() {
        let currentTemperature: [Float] = [12,16,18,10,14,13,11,20]
        let maxTemperature: [Float] = [32,24,20,21,23]
        let minTemperature: [Float] = [10,9,8,7,6,5]
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = documentDirectory.appendingPathComponent("citys")
            if FileManager.default.fileExists(atPath: path.path), let data = try? Data(contentsOf: path), let decodingData = try? decoder.decode([FavoriteDataModel].self, from: data) {
                self.totalData = decodingData
            }
            else {
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
                                                                           locationCoordinate: CGPoint(x: x, y: y), skyState: "맑음"))
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
                    print("error")
                }
                
            }
        }
    }
    
    func getData() -> Observable<[FavoriteDataModel]> {
        return .just(totalData)
    }
    
    func changeData(_ cityId: String) {
        let encoder = JSONEncoder()
        for i in 0..<totalData.count {
            if totalData[i].cityId == cityId {
                totalData[i].isFavorite.toggle()
            }
        }
        
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try? encoder.encode(totalData)
        if let data = jsonData, let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentDirectory.appendingPathComponent("citys")
            do {
                try data.write(to: path)
            } catch {
                print("write error!!")
            }
        }
    }
    func upDateDetailData(model: FavoriteDataModel) -> Observable<FavoriteDataModel> {
        return .empty()
    }
}
        
