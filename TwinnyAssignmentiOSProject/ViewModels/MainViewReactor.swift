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
    
    enum Action {
        case setTotalData
    }
    
    enum Mutation {
        case favoriteData([FavoriteDataModel])
    }
    
    struct State {
        var filterData: [FavoriteDataModel] = []
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .favoriteData(let array):
            state.filterData = array
            return state
        }
        
    }
}
