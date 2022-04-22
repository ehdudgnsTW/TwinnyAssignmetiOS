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
    
    init(_ state: FavoriteDataModel) {
        self.initialState = state
    }
}
