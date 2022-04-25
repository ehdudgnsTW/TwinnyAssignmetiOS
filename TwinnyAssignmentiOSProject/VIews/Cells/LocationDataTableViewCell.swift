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
    
    typealias Reactor = CellReactor
    var disposeBag: DisposeBag = DisposeBag()
    weak var delegate: FavoriteDelegate?

    private let cityName: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor(nil, font: 20, weight: .medium, nil)
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_black"), 20, 20), for: .normal)
        return button
    }()
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureStyle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStyle() {
        
        self.contentView.addSubview(cityName)
        self.contentView.addSubview(favoriteButton)
        
        
        cityName.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(favoriteButton.snp.leading)
        }
        
        favoriteButton.snp.makeConstraints {
            make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(cityName.snp.trailing)
            make.width.equalTo(40)
        }
        
        
    }
    
    func bind(reactor: CellReactor) {
        cityName.text = reactor.initialState.dataModel.cityName
        favoriteButton.favoriteStateStarImageSetting(status: reactor.initialState.dataModel.isFavorite)
        
        favoriteButton.rx.tap.subscribe (onNext: { [weak self] in
            self?.delegate?.changeFavoriteState(reactor.initialState.dataModel.cityId,true)
        }).disposed(by: disposeBag)
    }
}
