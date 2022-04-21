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

class MainViewController: UIViewController,View {
    
    typealias Reactor = MainViewReactor
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
        self.rx.viewWillAppear.map {
            Reactor.Action.filtering(nil, false)
        }.bind(to: reactor.action).disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidBeginEditing
            .map {
                Reactor.Action.filtering(self.searchController.searchBar.text, true)
            }.bind(to: reactor.action).disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.map {
            Reactor.Action.filtering($0, true)
        }.bind(to: reactor.action).disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidEndEditing.map {
            Reactor.Action.filtering(nil, false)
        }.bind(to: reactor.action).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MainViewReactor.State.FilterData.self).subscribe(onNext: { [unowned self]
            model in
            let reactor = DetailViewReactor(model: model.filteringData)
            let vc = FavoriteDetailDataViewController(reactor: reactor)
            self.navigationController?.pushViewController(vc, animated: false)
        }).disposed(by: disposeBag)
                
        reactor.state.map {
            $0.filterData
        }.bind(to: tableView.rx.items) {
            tablView, row, item in
            if item.isSearching {
                guard let cell = tablView.dequeueReusableCell(withIdentifier: "LocationDataTableViewCell") as? LocationDataTableViewCell
                else { return LocationDataTableViewCell() }
                let cellReactor = CellReactor(model: item.filteringData)
                cell.configureDataView(reactor: cellReactor)
                cell.selectionStyle = .none
                cell.reactor = reactor
                return cell
            }
            else {
                guard let cell = tablView.dequeueReusableCell(withIdentifier: "FavoriteDataTableViewCell") as? FavoriteDataTableViewCell
                else { return FavoriteDataTableViewCell() }
                let cellReactor = CellReactor(model: item.filteringData)
                cell.configureDataView(reactor: cellReactor)
                cell.selectionStyle = .none
                cell.reactor = reactor
                return cell
            }
        }.disposed(by: disposeBag)
        
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
        tableView.register(LocationDataTableViewCell.self, forCellReuseIdentifier: "LocationDataTableViewCell")
        tableView.register(FavoriteDataTableViewCell.self, forCellReuseIdentifier: "FavoriteDataTableViewCell")
        tableView.snp.makeConstraints {
            make in
            make.top.trailing.leading.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }    
}


