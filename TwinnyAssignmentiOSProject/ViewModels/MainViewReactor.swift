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
    
    private let repository = MockRepository.shared
    private var searchWord: String?
    
    enum Action {
        case filtering(String?, Bool)
        case changeFavoriteStatus(String, Bool)
    }
    
    enum Mutation {
        case filteringData([FavoriteDataModel], Bool)
    }
    
    struct State {
        var filterData: [CellReactor] = []
    }
    
    var initialState: State = State()

    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filtering(let text, let isSearching):
            searchWord = text
           return reloadData(text, isSearching)
        case .changeFavoriteStatus(let id, let isSearching):
            repository.changeData(id)
            let text = self.searchWord
            return reloadData(text, isSearching)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .filteringData(let array, let isSearching):
            state.filterData = array.map {
                CellReactor($0, isSearching)
            }
            return state
        }
        
    }
}

extension MainViewReactor {
    func reloadData(_ text:String?,_ isSearching: Bool) -> Observable<Mutation> {
        return repository.getData()
            .map { $0.filter { isSearching ? (text?.isEmpty == false ? $0.cityName.contains(text!): true) : $0.isFavorite } }
             .map { .filteringData($0, isSearching) }
    }
}
