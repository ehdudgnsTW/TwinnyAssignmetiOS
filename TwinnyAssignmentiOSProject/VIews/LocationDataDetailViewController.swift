//
//  LocationDataDetailViewController.swift
//  TwinnyAssignmentiOSProject
//
//  Created by 도영훈 on 2022/02/15.
//

import UIKit

class LocationDataDetailViewController: UIViewController {
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    private var viewModel = LocationDataDetailViewModel()
    
    //fb: LocationDataDetailViewController로 down casting 된 인스턴스를 다시 up casting하여 반환하는 것은 비효율적입니다.
    //인스턴스 내 속성에 접근하려면 사용처에서 다시 down casting을 해야 합니다.
    static var instance: UIViewController = {
        UIStoryboard(name: "LocationDataDetail", bundle: nil).instantiateInitialViewController() as? LocationDataDetailViewController ?? LocationDataDetailViewController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData()
        
    }

}
