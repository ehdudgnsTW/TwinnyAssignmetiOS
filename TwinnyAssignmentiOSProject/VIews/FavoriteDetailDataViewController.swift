//
//  FavoriteDetailDataViewController.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Toast_Swift

class FavoriteDetailDataViewController: UIViewController,View {

    typealias Reactor = DetailViewReactor
    var disposeBag: DisposeBag = DisposeBag()
    
    private let currentTemperature: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("12", font: 40, weight: .bold, nil)
        label.textAlignment = .center
        return label
    }()
    
    private let maxTemperature: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("14", font: 20, weight: .medium, nil)
        label.textAlignment = .left
        return label
    }()
    
    private let minTemperature: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("8", font: 20, weight: .medium, nil)
        label.textAlignment = .left
        return label
    }()
    
    private let cityName: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("서울시 용문구 용문동", font: 20, weight: .medium, nil)
        label.textAlignment = .center
        return label
    }()
    
    private let markMax: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("최고:", font: 20, weight: .medium, nil)
        label.textAlignment = .right
        return label
    }()
    
    private let markMin: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("최저:", font: 20, weight: .medium, nil)
        label.textAlignment = .right
        return label
    }()
    
    private let divideView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let weatherConditionImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let weatherConditionLabel: UILabel = {
        let label = UILabel()
        return label
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
    
   
    func bind(reactor: DetailViewReactor) {
        
        currentTemperature.text = reactor.initialState.dataModel.currentTemperature.description
        cityName.text = reactor.initialState.dataModel.cityName
        maxTemperature.text = reactor.initialState.dataModel.maxTemperature.description
        minTemperature.text = reactor.initialState.dataModel.minTemperature.description
        
        self.rx.viewWillAppear.map {
            Reactor.Action.updateData
        }.bind(to: reactor.action).disposed(by: disposeBag)
        
        favoriteButton.rx.tap.map {
            Reactor.Action.changeFavorite
        }.bind(to:reactor.action).disposed(by: disposeBag)
            
        reactor.state.map{ $0.dataModel}
            .bind(onNext: {
                self.currentTemperature.text = $0.currentTemperature.description
                self.maxTemperature.text = $0.maxTemperature.description
                self.minTemperature.text = $0.minTemperature.description
                self.weatherConditionImage.setSkyImage(state: $0.skyState, 100, 100)
                self.weatherConditionLabel.setWeatherStateText(state: $0.skyState)
                self.favoriteButton.favoriteStateStarImageSetting(status: $0.isFavorite)
            })
            .disposed(by: disposeBag)
        
        reactor.state.bind(onNext: {
            self.view.hideToast()
            self.view.makeToast($0.message, point: CGPoint(x: self.view.frame.midX, y: self.view.frame.maxY-40), title: nil, image: nil,completion: nil)
        }).disposed(by: disposeBag)
    }
    
    private func initView() {
        view.backgroundColor = .white
        configureConstraints()
    }
    
    private func configureConstraints() {
        [markMax,maxTemperature,markMin,minTemperature].forEach{
            stackView.addArrangedSubview($0)
        }
        
        [currentTemperature,stackView,cityName,divideView,favoriteButton,weatherConditionImage,weatherConditionLabel].forEach {
            self.view.addSubview($0)
        }
        
        favoriteButton.snp.makeConstraints {
            make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.width.height.equalTo(30)
        }
        
        currentTemperature.snp.makeConstraints {
            make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(74)
            make.bottom.equalTo(cityName.snp.top).inset(-20)
            make.height.equalTo(48).priority(.high)
        }
        
        cityName.snp.makeConstraints {
            make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(currentTemperature.snp.bottom).offset(20)
            make.bottom.equalTo(stackView.snp.top).offset(-47)
            make.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(cityName.snp.bottom).offset(47)
            make.bottom.equalTo(divideView.snp.top).offset(-83)
            make.height.equalTo(24)
        }
        
        divideView.snp.makeConstraints {
            make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(3)
            make.top.equalTo(stackView.snp.bottom).offset(83)
        }
        
        weatherConditionImage.snp.makeConstraints {
            make in
            make.centerX.equalToSuperview()
            make.top.equalTo(divideView.snp.bottom).offset(20)
        }
        
        weatherConditionLabel.snp.makeConstraints {
            make in
            make.top.equalTo(weatherConditionImage.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            
        }
    }
    
}
