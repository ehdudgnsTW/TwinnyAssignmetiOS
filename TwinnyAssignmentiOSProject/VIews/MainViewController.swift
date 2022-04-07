//
//  MainViewController.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private var filterString: [String] = ["seoul","busan","deajeon","ulsan","kangwon","수원"]
    private var favoriteData: [FavoriteDataModel] = [FavoriteDataModel(cityTemperature: 12, cityName: "서울"),
                                                       FavoriteDataModel(cityTemperature: 12, cityName: "대전"),
                                                       FavoriteDataModel(cityTemperature: 12, cityName: "부산"),
                                                       FavoriteDataModel(cityTemperature: 12, cityName: "울산"),
                                                       FavoriteDataModel(cityTemperature: 12, cityName: "강원")]
    
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
        tableView.reloadData()
        print("text:\(text)")
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FavoriteDetailDataViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching {
            return 44
        }
        return 100

    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterString.count
        }
        return favoriteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDataTableViewCell") as? LocationDataTableViewCell else {
                return LocationDataTableViewCell()
            }
            cell.selectionStyle = .none
            cell.configureSearchingView(filterString[indexPath.row])
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteDataTableViewCell") as? FavoriteDataTableViewCell else {
                return FavoriteDataTableViewCell()
            }
            cell.selectionStyle = .none
            cell.configureFavoriteView(favoriteData[indexPath.row])
            return cell
        }
    }
}
