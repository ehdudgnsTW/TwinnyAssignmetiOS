//
//  MainViewController.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit
import SnapKit
import RxSwift
import ReactorKit
import RxCocoa

protocol FavoriteDelegate: NSObject {
    var isSearching:Bool { get set }
    func changeFavoriteState(_ cityId: String, _ status: Bool)
}


class MainViewController: UIViewController,View,FavoriteDelegate {
    
    typealias Reactor = MainViewReactor
    var isSearching: Bool = false
    var disposeBag: DisposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func bind(reactor: MainViewReactor) {
        
        self.rx.viewWillAppear.withLatestFrom(searchController.searchBar.rx.text)
            .map { .filtering($0, $0?.isEmpty == false || self.isSearching) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        searchController.rx.willPresent
            .map { .filtering(nil, true) }
            .debug()
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchController.rx.willDismiss
            .map { .filtering(nil, false) }
            .debug()
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchController.rx.willPresent
            .flatMapLatest { [unowned self] in
                return self.searchController.searchBar.rx.text.distinctUntilChanged()
                    .take(until: self.searchController.rx.willDismiss)
            }.map { .filtering($0, true) }
            .bind(to: reactor.action).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CellReactor.self).subscribe(onNext: { [unowned self]
            model in
            let reactor = DetailViewReactor(model: model.initialState.dataModel)
            let vc = FavoriteDetailDataViewController(reactor: reactor, isSearching: model.initialState.isSearching)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: false)
        }).disposed(by: disposeBag)
           
        
        
        reactor.state.map {
            $0.filterData
        }.bind(to: tableView.rx.items) {
            tablView, row, item in
            let cellReactor = item
            if cellReactor.initialState.isSearching {
                guard let cell = tablView.dequeueReusableCell(withIdentifier: "LocationDataTableViewCell") as? LocationDataTableViewCell
                else { return LocationDataTableViewCell() }
                cell.selectionStyle = .none
                cell.delegate = self
                cell.reactor = cellReactor
                return cell
            }
            else {
                guard let cell = tablView.dequeueReusableCell(withIdentifier: "FavoriteDataTableViewCell") as? FavoriteDataTableViewCell
                else { return FavoriteDataTableViewCell() }
                cell.selectionStyle = .none
                cell.reactor = cellReactor
                cell.delegate = self
                return cell
            }
        }.disposed(by: disposeBag)
        
    }
    
    func changeFavoriteState(_ cityId: String, _ status: Bool) {
        reactor?.action.onNext(.changeFavoriteStatus(cityId, status))
        
    }
    
    private func initView() {
        view.backgroundColor = .white
        configureSearchBar()
        configureTableView()
    }
    
    private func configureSearchBar() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "오늘의 날씨"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        
        self.view.addSubview(tableView)
        tableView.keyboardDismissMode = .onDrag
        tableView.register(LocationDataTableViewCell.self, forCellReuseIdentifier: "LocationDataTableViewCell")
        tableView.register(FavoriteDataTableViewCell.self, forCellReuseIdentifier: "FavoriteDataTableViewCell")
        tableView.snp.makeConstraints {
            make in
            make.top.trailing.leading.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }    
}

