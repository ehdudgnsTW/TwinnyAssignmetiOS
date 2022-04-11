//
//  MainViewReactor.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import Foundation
import ReactorKit
import RxSwift
import RxRelay

class MainViewReactor {
    
    private var repository:RepositoryProtocol = MockRepository()
    private var totalData: [FavoriteDataModel] = []
    private let disposBag: DisposeBag = DisposeBag()
    
    init() {
        repository.getCSVFileToData().subscribe({
            data in
            if let data = data.element {
                self.totalData = data
            }
        }).disposed(by: disposBag)
    }

    func favoriteData() -> Observable<[FavoriteDataModel]> {
        let resultArray = totalData.filter {
            $0.isFavorite
        }
        return .just(resultArray)
    }

    func searchFilterData(txt: String) -> Observable<[FavoriteDataModel]> {
        if txt != " " {
            var resultArray: [FavoriteDataModel] = []
            resultArray = totalData.filter {
                $0.cityName.contains(txt)
            }
            return .just(resultArray)
        }
        else {
            return .just(totalData)
        }
    }
    
   
}
