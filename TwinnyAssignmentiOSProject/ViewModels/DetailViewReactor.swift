//
//  DetailViewReactor.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/20.
//

import Foundation
import ReactorKit
import RxSwift

class DetailViewReactor: Reactor {
    
    private var repository = MockRepository.shared
    
    enum Action {
        case changeFavorite
    }
    
    enum Mutation {
        case changeFavoriteState
    }
    
    struct State {
        var dataModel: FavoriteDataModel
    }
    
    var initialState: State
    
    init(model: FavoriteDataModel) {
        self.initialState = State(dataModel: model)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeFavorite:
            repository.changeData(initialState.dataModel.cityId)
            return .just(.changeFavoriteState)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .changeFavoriteState:
            state.dataModel.isFavorite.toggle()
            return state
        }
    }
}
