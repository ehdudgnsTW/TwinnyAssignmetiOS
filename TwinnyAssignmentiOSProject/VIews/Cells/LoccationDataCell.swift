//
//  LoccationDataCell.swift
//  TwinnyAssignmentiOSProject
//
//  Created by 도영훈 on 2022/02/15.
//

import UIKit

class LoccationDataCell: UITableViewCell {

    @IBOutlet weak var findLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(location: String) {
        findLocation.text = location
    }
    
}
