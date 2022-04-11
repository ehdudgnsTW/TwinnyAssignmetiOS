//
//  FavoriteDetailDataViewController.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/07.
//

import UIKit

class FavoriteDetailDataViewController: UIViewController {
    
    private var detailData: FavoriteDataModel
    
    private let currentTemperature: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("nil", font: 40, weight: .bold, nil)
        label.textAlignment = .center
        return label
    }()
    
    private let maxTemperature: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("nil", font: 20, weight: .medium, nil)
        label.textAlignment = .left
        return label
    }()
    
    private let minTemperature: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("nil", font: 20, weight: .medium, nil)
        label.textAlignment = .left
        return label
    }()
    
    private let cityName: UILabel = {
        let label = UILabel()
        label.setTextFontWeightColor("nil", font: 20, weight: .medium, nil)
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
        button.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_yellow"), 20, 20), for: .normal)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init(detailData: FavoriteDataModel) {
        self.detailData = detailData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        let view = UIView()
        self.view = view
        
        view.backgroundColor = .white
        configureConstraints()
    }
    
    private func configurData() {
        
        currentTemperature.text = "\(detailData.avgTemperature)"
        maxTemperature.text = "\(detailData.maxTemperature)"
        minTemperature.text = "\(detailData.minTemperature)"
        cityName.text = detailData.cityName
        
        if detailData.isFavorite {
            favoriteButton.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_yellow"), 20, 20), for: .normal)
        }
        else {
            favoriteButton.setImage(SizeStyle.resizeImage(image: UIImage(named: "star_black"), 20, 20), for: .normal)
        }
        
    }
    
    private func configureConstraints() {
        [markMax,maxTemperature,markMin,minTemperature].forEach{
            stackView.addArrangedSubview($0)
        }
        
        [currentTemperature,stackView,cityName,divideView,favoriteButton].forEach {
            self.view.addSubview($0)
        }
        
        configurData()
        
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
        }
        
        cityName.snp.makeConstraints {
            make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(currentTemperature.snp.bottom).offset(20)
            make.bottom.equalTo(stackView.snp.top).offset(-47)
        }
        
        stackView.snp.makeConstraints {
            make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(cityName.snp.bottom).offset(47)
            make.bottom.equalTo(divideView.snp.top).offset(-83)
        }
        
        divideView.snp.makeConstraints {
            make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(3)
            make.top.equalTo(stackView.snp.bottom).offset(83)
        }
    }
    
}
