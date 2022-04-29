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
    
    private var repository = Repository.shared
    private var disposeBag = DisposeBag()
    
    enum Action {
        case changeFavorite
        case updateData
    }
    
    enum Mutation {
        case changeFavoriteState
        case getmodelData(FavoriteDataModel, String)
    }
    
    struct State {
        var dataModel: FavoriteDataModel
        var message: String
    }
    
    var initialState: State
    
    init(model: FavoriteDataModel) {
        self.initialState = State(dataModel: model, message: "업데이트 중")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeFavorite:
            repository.changeData(initialState.dataModel.cityId)
            return .just(.changeFavoriteState)
        case .updateData:
            repository.upDateDetailData(model: initialState.dataModel)
            return repository.detailDataSubject.map {
                DetailViewReactor.Mutation.getmodelData($0,"업데이트 완료!!")
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .changeFavoriteState:
            state.dataModel.isFavorite.toggle()
            state.message = "즐겨찾기 상태 변경 완료"
            return state
        case .getmodelData(let model, let message):
            state.dataModel = model
            state.message = message
            return state
        }
    }
}
