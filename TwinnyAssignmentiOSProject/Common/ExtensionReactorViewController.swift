//
//  ExtensionReactorViewController.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/18.
//

import UIKit
import ReactorKit
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}

