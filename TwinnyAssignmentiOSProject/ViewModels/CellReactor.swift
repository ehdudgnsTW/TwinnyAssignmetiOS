//
//  CellReactor.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/21.
//

import Foundation
import ReactorKit


class CellReactor: Reactor {
    typealias Action = NoAction
    var initialState: FavoriteDataModel
    var isSearching: Bool
    
    init(_ state: FavoriteDataModel, _ isSearching: Bool) {
        self.initialState = state
        self.isSearching = isSearching
    }
}
