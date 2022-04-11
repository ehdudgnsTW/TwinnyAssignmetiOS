//
//  FavoriteDataTableViewCell.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class FavoriteDataTableViewCell: UITableViewCell {

    typealias Reactor = TableViewCellReactor
    var disposeBag: DisposeBag = DisposeBag()
    private var favoriteData: FavoriteDataModel? = nil
    
    private let cityName: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor(nil, font: 20, weight: .medium, nil)
        return label
    }()
    
    private let cityTemperature: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor(nil, font: 30, weight: .bold, nil)
        label.textAlignment = .center
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.imageMoveRight()
        button.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_yellow"), 30, 30), for: .normal)
        return button
    }()
    
    func bind(reactor: Reactor) {
        if let favoriteData = favoriteData {
            favoriteButton.rx.tap.map {
                return Reactor.Action.favorite(id: favoriteData.index, check: favoriteData.isFavorite)
            }.bind(to: reactor.action).disposed(by: disposeBag)
        }
        
        reactor.state.map {
            return $0 }.compactMap { $0 }.bind(onNext: {
            data in
            print("f:\(data)")
        }).disposed(by: disposeBag)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    func configureFavoriteView(_ favoriteContents: FavoriteDataModel) {
        self.addSubview(cityTemperature)
        self.addSubview(cityName)
        self.contentView.addSubview(favoriteButton)
        
        favoriteData = favoriteContents
        cityName.text = favoriteContents.cityName
        cityName.textAlignment = .right
        cityTemperature.text = "\(favoriteContents.avgTemperature)"
        
        favoriteButton.snp.makeConstraints {
            make in
            make.width.height.equalTo(50)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(cityName.snp.top)
        }
        
        cityTemperature.snp.makeConstraints {
            make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(cityName.snp.leading)
            make.width.equalTo(100)
        }
        
        cityName.snp.makeConstraints {
            make in
            make.top.equalTo(favoriteButton.snp.bottom)
            make.leading.equalTo(cityTemperature.snp.trailing)
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview().offset(-25)
        }
    }

}
