//
//  LocationDataTableViewCell.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit
import SnapKit
import ReactorKit

class LocationDataTableViewCell: UITableViewCell,View {
    
    typealias Reactor = MainViewReactor
    var disposeBag: DisposeBag = DisposeBag()
    private var dataModel: FavoriteDataModel!

    private let cityName: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor(nil, font: 20, weight: .medium, nil)
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.imageMoveRight()
        button.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_black"), 20, 20), for: .normal)
        return button
    }()
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func bind(reactor: MainViewReactor) {
        favoriteButton.rx.tap.map {
            Reactor.Action.changeFavorite(self.dataModel, true)
        }.bind(to: reactor.action).disposed(by: disposeBag)
    }
    
    func configureSearchingView(_ searchContents: FavoriteDataModel) {
        dataModel = searchContents
        self.addSubview(cityName)
        self.addSubview(favoriteButton)
        
        cityName.text = searchContents.cityName
        favoriteButton.imageSetting(status: searchContents.isFavoriet)
        
        cityName.snp.makeConstraints {
            make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(favoriteButton.snp.leading)
        }
        
        favoriteButton.snp.makeConstraints {
            make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(cityName.snp.trailing)
        }
        
    }

}
