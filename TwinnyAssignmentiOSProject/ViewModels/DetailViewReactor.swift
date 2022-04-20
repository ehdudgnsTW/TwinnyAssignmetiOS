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
    
    private var repository: RepositoryProtocol = MockRepository()
    private var totalData: [FavoriteDataModel] = []
    
    enum Action {
        case changeFavorite(FavoriteDataModel)
    }
    
    enum Mutation {
        case changeFavoriteState(Bool)
    }
    
    struct State {
        var favoriteState: Bool = true
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
        case .changeFavorite(let model):
            var status: Bool = true
            for i in 0..<totalData.count {
                if totalData[i].cityId == model.cityId {
                    totalData[i].isFavorite.toggle()
                    status = totalData[i].isFavorite
                }
            }
            repository.changeTotalData(totoalData: totalData)
            return .just(Mutation.changeFavoriteState(status))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .changeFavoriteState(let status):
            state.favoriteState = status
        }
        return state
    }
}
