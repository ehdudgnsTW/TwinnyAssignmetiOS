//
//  LocationDataTableViewCell.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class LocationDataTableViewCell: UITableViewCell {

    typealias Reactor = TableViewCellReactor
    var disposeBag: DisposeBag = DisposeBag()
    private var favoriteData: FavoriteDataModel? = nil
    
    private let cityName: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor(nil, font: 20, weight: .medium, nil)
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.imageMoveRight()
        return button
    }()
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    
    func bind(reactor: Reactor) {
        if let favoriteData = favoriteData {
            favoriteButton.rx.tap.map {
                return Reactor.Action.favorite(id: favoriteData.index, check: favoriteData.isFavorite)
            }.bind(to: reactor.action).disposed(by: disposeBag)
        }
        
        reactor.state.map { $0 }.compactMap{$0}.bind(onNext: {
            data in
            print("l: \(data)")
        }).disposed(by: disposeBag)
    }
    
    func configureSearchingView(_ searchContents: FavoriteDataModel) {
        favoriteData = searchContents
        cityName.text = searchContents.cityName
        if searchContents.isFavorite {
            favoriteButton.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_yellow"), 20, 20), for: .normal)
        }
        else {
            favoriteButton.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_black"), 20, 20), for: .normal)
        }
        
        self.addSubview(cityName)
        self.contentView.addSubview(favoriteButton)
        
        
        
        cityName.snp.makeConstraints {
            make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(favoriteButton.snp.leading)
        }
        
        favoriteButton.snp.makeConstraints {
            make in
            make.width.equalTo(40)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(cityName.snp.trailing)
        }
        
    }

}
