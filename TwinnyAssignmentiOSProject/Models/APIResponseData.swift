//
//  APIResponseData.swift
//  TwinnyAssignmentiOSProject
//
//  Created by twinny on 2022/04/25.
//

import Foundation

struct ResponseData: Codable {
    var response: Response
    
    struct Response: Codable {
        var header: Header
        var body: Body?
        struct Header: Codable {
            var resultCode: String
            var resultMsg: String
        }
        
        struct Body: Codable {
            var items: Items
            
            struct Items: Codable {
                var item: [Item]
                
                struct Item: Codable {
                    let baseDate: String
                    let baseTime: String
                    let category: String
                    let fcstDate: String
                    let fcstTime: String
                    let fcstValue: String
                }
            }
        }
    }
}
