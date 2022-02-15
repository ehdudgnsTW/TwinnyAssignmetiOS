//
//  LocationDataDetailViewModel.swift
//  TwinnyAssignmentiOSProject
//
//  Created by 도영훈 on 2022/02/15.
//

import Foundation

class Location: NSObject {
    @objc dynamic var locationData : DataModel = DataModel(locationName: "", max: "", min: "", temp: "")
}

class LocationDataDetailViewModel {
    private var repository = API()
    private var observation : NSKeyValueObservation!
    
    init() {
        observation = self.repository.dataResult.observe(\.result, options: .new) {_,_ in
            print("change")
        }
    }
    func getData() {
        
    }
    
}
