//
//  MainViewReactor.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import Foundation
import ReactorKit
import RxSwift

class MainViewReactor: Reactor {
    
    private let repository = MockRepository()
    private var totalData: [FavoriteDataModel] = []
    private var favoriteDatas: [FavoriteDataModel] = []
    private var searchingDatas: [FavoriteDataModel] = []
    
    enum Action {
        case setTotalData
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
            favoriteDatas = totalData.filter {
                $0.isFavoriet
            }
            return .just(Mutation.favoriteData(favoriteDatas))
        case .searchText(let targetText):
            if let text = targetText, targetText != "" {
                searchingDatas = totalData.filter {
                    $0.cityName.contains(text)
                }
                return .just(Mutation.searchingData(searchingDatas))
            }
            else {
                return .just(Mutation.searchingData(totalData))
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
