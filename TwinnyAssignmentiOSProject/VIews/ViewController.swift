//
//  ViewController.swift
//  TwinnyAssignmentiOSProject
//
//  Created by 도영훈 on 2022/02/08.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var favoritesLocation: UITableView!
    //fb: 나머지 전역변수를 viewModel에 포함하는 방향도 괜찮아보입니다.
    private let viewModel = MainViewModel()
    private var filteredArr: [String] = []
    private var currentTime: String = ""
    private var currentDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRegister()
        viewModel.getCSVFile()
        setupSearchController()
        getTime()
    }
    
    private func getTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "HHmm"
        currentTime = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "yyyyMMdd"
        currentDate = dateFormatter.string(from: Date())
    }
    
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    //fb: whiltespace로 검색 시 '1단계 2단계 3단계'가 검색됩니다.
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "찾으시는 장소를 입력해주세요."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setRegister() {
        favoritesLocation.delegate = self
        favoritesLocation.dataSource = self
        if isFiltering {
            //fb: viewDidLoad에 한 번만 호출되기 때문에 WeatherLocationDataCell 셀은 등록되지 않습니다.
            favoritesLocation.register(UINib(nibName: "WeatherLocationDataCell", bundle: nil), forCellReuseIdentifier: "WeatherLocationDataCell")
        }
        else {
            favoritesLocation.register(UINib(nibName: "LoccationDataCell", bundle: nil), forCellReuseIdentifier: "LoccationDataCell")
        }
    }


}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    //fb: datasource와 delegate를 나누려 했다면, 이 메서드는 'extension ViewController: UITableViewDelegate { ... }'에 위치하는 것이 나아 보입니다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getTime()
        viewModel.getData(location: filteredArr[indexPath.row], baseTime: currentTime, baseDate: currentDate)
        
        let vc = LocationDataDetailViewController.instance
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredArr.count : viewModel.favoriteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFiltering {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoccationDataCell", for: indexPath) as? LoccationDataCell else {
                return LoccationDataCell()
            }
            cell.configure(location: filteredArr[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherLocationDataCell", for: indexPath) as? WeatherLocationDataCell else {
                return WeatherLocationDataCell()
            }
            cell.configure(temp: "12", location: "서울특별시 강남구 대치동")
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

extension ViewController:UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredArr = viewModel.findData(location: text)
        favoritesLocation.reloadData()
    }
}

