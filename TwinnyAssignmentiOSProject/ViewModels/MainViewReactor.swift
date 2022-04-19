//
//  MainViewReactor.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import Foundation
import ReactorKit
import RxSwift
import UIKit

class MainViewReactor: Reactor {
    
    private let repository = MockRepository()
    private var totalData: [FavoriteDataModel] = []
    private var searchWord: String = ""
    
    enum Action {
        case favoriteData
        case changeFavorite(FavoriteDataModel,Bool)
        case searchText(String?)
    }
    
    enum Mutation {
        case filteringData([FavoriteDataModel], Bool)
    }
    
    struct State {
        var filterData: [FavoriteDataModel] = []
        var isSearching: Bool = false
    }
    
    var initialState: State = State()
    
    init() {
        repository.getTotalData().subscribe {
            data in
            self.totalData = data
        }.disposed(by: DisposeBag())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .favoriteData:
            let favoriteDatas = totalData.filter {
                $0.isFavorite
            }
            return .just(Mutation.filteringData(favoriteDatas, false))
        case .searchText(let targetText):
            if let text = targetText, targetText != "" {
                searchWord = text
                let searchingDatas = totalData.filter {
                    $0.cityName.contains(text)
                }
                return .just(Mutation.filteringData(searchingDatas, true))
            }
            else {
                return .just(Mutation.filteringData(totalData, true))
            }
        case .changeFavorite(let model, let isSearching):
            for i in 0..<totalData.count {
                if model.cityId == totalData[i].cityId {
                    totalData[i].isFavorite.toggle()
                }
            }
            repository.changeTotalData(totoalData: totalData)
            if isSearching {
                if searchWord != "" {
                    let searchingDatas = totalData.filter {
                        $0.cityName.contains(self.searchWord)
                    }
                    return .just(Mutation.filteringData(searchingDatas, true))
                }
                else {
                    return .just(Mutation.filteringData(totalData, true))
                }
                
            }
            else {
                let favoriteDatas = totalData.filter {
                    $0.isFavorite
                }
                return .just(Mutation.filteringData(favoriteDatas, false))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .filteringData(let array, let isSearching):
            state.isSearching = isSearching
            state.filterData = array
            return state
        }
        
    }
}
