//
//  FavoriteDataTableViewCell.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit
import ReactorKit

class FavoriteDataTableViewCell: UITableViewCell,View {
    
    typealias Reactor = CellReactor
    weak var delegate: FavoriteDelegate?
    var disposeBag: DisposeBag = DisposeBag()

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
        button.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_yellow"), 30, 30), for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStyle() {
        self.contentView.addSubview(cityTemperature)
        self.contentView.addSubview(cityName)
        self.contentView.addSubview(favoriteButton)
        
        favoriteButton.snp.makeConstraints {
            make in
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(cityName.snp.top)
            make.width.equalTo(40)
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
            make.height.equalTo(40)
        }
    }
    
    func bind(reactor: CellReactor) {
        cityName.text = reactor.initialState.cityName
        cityTemperature.text = reactor.initialState.currentTemperature.description
        
        favoriteButton.rx.tap.subscribe (onNext: { [weak self] in
            self?.delegate?.changeFavoriteState(reactor.initialState.cityId,false)
        }).disposed(by: disposeBag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
