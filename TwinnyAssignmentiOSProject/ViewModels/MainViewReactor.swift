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
        case setTotalData
        case favoriteData
        case changeFavorite(FavoriteDataModel,Bool)
        case searchText(String?)
    }
    
    enum Mutation {
        case favoriteData([FavoriteDataModel])
        case searchingData([FavoriteDataModel])
    }
    
    struct State {
        var filterData: [FavoriteDataModel] = []
        var isSearching: Bool = false
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setTotalData:
            repository.getCSVFileToData().subscribe {
                data in
                self.totalData = data
            }.disposed(by: DisposeBag())
            let favoriteDatas = totalData.filter {
                $0.isFavoriet
            }
            return .just(Mutation.favoriteData(favoriteDatas))
        case .favoriteData:
            let favoriteDatas = totalData.filter {
                $0.isFavoriet
            }
            return .just(Mutation.favoriteData(favoriteDatas))
            
        case .searchText(let targetText):
            if let text = targetText, targetText != "" {
                searchWord = text
                let searchingDatas = totalData.filter {
                    $0.cityName.contains(text)
                }
                return .just(Mutation.searchingData(searchingDatas))
            }
            else {
                return .just(Mutation.searchingData(totalData))
            }
        case .changeFavorite(let model, let isSearching):
            for i in 0..<totalData.count {
                if model.cityId == totalData[i].cityId {
                    totalData[i].isFavoriet.toggle()
                }
            }
            if isSearching {
                if searchWord != "" {
                    let searchingDatas = totalData.filter {
                        $0.cityName.contains(self.searchWord)
                    }
                    return .just(Mutation.searchingData(searchingDatas))
                }
                else {
                    return .just(Mutation.searchingData(totalData))
                }
                
            }
            else {
                let favoriteDatas = totalData.filter {
                    $0.isFavoriet
                }
                return .just(Mutation.favoriteData(favoriteDatas))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .favoriteData(let array):
            state.isSearching = false
            state.filterData = array
            return state
        case .searchingData(let array):
            state.isSearching = true
            state.filterData = array
            return state
        }
        
    }
}
