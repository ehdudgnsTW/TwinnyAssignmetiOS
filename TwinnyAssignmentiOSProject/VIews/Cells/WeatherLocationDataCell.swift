//
//  WeatherLocationTableViewCell.swift
//  TwinnyAssignmentiOSProject
//
//  Created by 도영훈 on 2022/02/09.
//

import UIKit

class WeatherLocationDataCell: UITableViewCell {
    
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(temp: String, location: String) {
        currentLocation.text = location
        currentTemperature.text = "\(temp)℃"
    }
    
}
