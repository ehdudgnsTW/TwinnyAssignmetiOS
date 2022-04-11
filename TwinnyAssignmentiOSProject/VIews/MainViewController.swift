//
//  MainViewController.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import SnapKit

class MainViewController: UIViewController {
    
    private let reactor: TableViewCellReactor = TableViewCellReactor()
    private let viewModel = MainViewReactor()
    private let disposeBag:DisposeBag = DisposeBag()
    private var searchData: [FavoriteDataModel] = []
    private var favoriteData: [FavoriteDataModel] = []
    
    private var isSearching: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
  
    
    private func initView() {
        let view = UIView()
        self.view = view
        view.backgroundColor = .white
        configureSearchBar()
        configureTableView()
        configureData() 
    }
    
    private func configureData() {
        viewModel.favoriteData().subscribe {
            data in
            self.favoriteData = data
        }.disposed(by: disposeBag)
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "오늘의 날씨"
        searchController.searchResultsUpdater = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        
        self.view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationDataTableViewCell.self, forCellReuseIdentifier: "LocationDataTableViewCell")
        tableView.register(FavoriteDataTableViewCell.self, forCellReuseIdentifier: "FavoriteDataTableViewCell")
        tableView.snp.makeConstraints {
            make in
            make.top.trailing.leading.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        viewModel.favoriteData().subscribe {
            data in
            self.favoriteData = data
        }.disposed(by: disposeBag)
        
        viewModel.searchFilterData(txt: text).subscribe {
            data in
            self.searchData = data
        }.disposed(by: disposeBag)
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc: UIViewController = UIViewController()
        if isSearching {
            vc = FavoriteDetailDataViewController(detailData: searchData[indexPath.row])
        }
        else {
            vc = FavoriteDetailDataViewController(detailData: favoriteData[indexPath.row])
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching {
            return 50
        }
        return 100

    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchData.count
        }
        return favoriteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDataTableViewCell") as? LocationDataTableViewCell else {
                return LocationDataTableViewCell()
            }
            cell.selectionStyle = .none
            cell.configureSearchingView(searchData[indexPath.row])
            cell.bind(reactor: self.reactor)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteDataTableViewCell") as? FavoriteDataTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configureFavoriteView(favoriteData[indexPath.row])
            cell.bind(reactor: self.reactor)
            return cell
        }
    }
}
