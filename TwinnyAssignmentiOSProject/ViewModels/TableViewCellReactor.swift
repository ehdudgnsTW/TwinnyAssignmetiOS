//
//  LocationDataTableViewReactor.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import Foundation
import RxSwift
import ReactorKit

class TableViewCellReactor: Reactor {
    
    enum Action {
        case favorite(id: Int, check: Bool)
    }
    
    enum Mutation {
        case favorite
    }
    
    struct State {
        var index: Int = 0
        var isFavorite: Bool = false
    }
    
    private var index: Int = 0
    private var isFavorite: Bool = false
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .favorite(id, check):
            index = id
            isFavorite = check
            return .just(Mutation.favorite)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = State()
        switch mutation {
        case .favorite:
            newState.index = index
            self.isFavorite.toggle()
            newState.isFavorite = self.isFavorite
        }
        return newState
    }
}
