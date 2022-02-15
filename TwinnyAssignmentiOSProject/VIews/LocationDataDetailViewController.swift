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
    
    static var instance: UIViewController = {
        UIStoryboard(name: "LocationDataDetail", bundle: nil).instantiateInitialViewController() as? LocationDataDetailViewController ?? LocationDataDetailViewController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData()
        
    }

}
