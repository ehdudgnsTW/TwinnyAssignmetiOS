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

@objc
protocol FavoriteDelegate {
    @objc func changeFavoriteState(_ cityId: String, _ status: Bool) -> [Any]
}

class MainViewController: UIViewController,View,FavoriteDelegate {
    
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
        
        self.rx.updateFavoriteDatas.map {
            Reactor.Action.changeFavoriteStatus($0[0] as! String, $0[1] as! Bool)
        }.bind(to: reactor.action).disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidBeginEditing
            .map {
                Reactor.Action.filtering(self.searchController.searchBar.text, true)
            }.bind(to: reactor.action).disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.distinctUntilChanged().map {
            Reactor.Action.filtering($0, true)
        }.bind(to: reactor.action).disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked.map {
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
                let cellReactor = CellReactor(item.filteringData)
                cell.selectionStyle = .none
                cell.delegate = self
                cell.reactor = cellReactor
                return cell
            }
            else {
                guard let cell = tablView.dequeueReusableCell(withIdentifier: "FavoriteDataTableViewCell") as? FavoriteDataTableViewCell
                else { return FavoriteDataTableViewCell() }
                let cellReactor = CellReactor(item.filteringData)
                cell.selectionStyle = .none
                cell.reactor = cellReactor
                cell.delegate = self
                return cell
            }
        }.disposed(by: disposeBag)
        
    }
    
    @objc func changeFavoriteState(_ cityId: String, _ status: Bool) -> [Any] {
        return [cityId,status]
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

extension Reactive where Base: MainViewController {
    var updateFavoriteDatas: ControlEvent<[Any]> {
        let source = self.methodInvoked(#selector(Base.changeFavoriteState)).map { data in
            data
        }
        return ControlEvent(events: source)
    }
}
