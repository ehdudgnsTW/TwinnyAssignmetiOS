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
    private var searchWord: String = ""
    
    enum Action {
        case filtering(String?, Bool)
        case changeFavoriteStatus(String, Bool)
    }
    
    enum Mutation {
        case filteringData([FavoriteDataModel], Bool)
    }
    
    struct State {
        var filterData: [FilterData] = []
        
        struct FilterData {
            var filteringData: FavoriteDataModel
            var isSearching: Bool
        }
    }
    
    var initialState: State = State()

    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filtering(let text, let isSearching):
            if isSearching {
                if let text = text, text != "" {
                    self.searchWord = text
                    return repository.getData(nil)
                        .map { $0.filter { $0.cityName.contains(text) } }
                        .map { .filteringData($0, true) }
                }
                else {
                    self.searchWord = ""
                    return repository.getData(nil)
                        .map { $0 }
                        .map { .filteringData($0, true) }
                }
            }
            else {
                return repository.getData(nil)
                    .map { $0.filter(\.isFavorite) }
                    .map { .filteringData($0, false) }
            }
        case .changeFavoriteStatus(let id, let isSearching):
            if isSearching {
                if self.searchWord != "" {
                    return repository.getData(id)
                        .map { $0.filter { $0.cityName.contains(self.searchWord) } }
                        .map { .filteringData($0, true) }
                }
                else {
                    return repository.getData(id)
                        .map { $0 }
                        .map { .filteringData($0, true) }
                }
            }
            return repository.getData(id)
                .map { $0.filter(\.isFavorite) }
                .map { .filteringData($0, false) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .filteringData(let array, let isSearching):
            state.filterData = array.map {
                State.FilterData(filteringData: $0, isSearching: isSearching)
            }
            return state
        }
        
    }
}
