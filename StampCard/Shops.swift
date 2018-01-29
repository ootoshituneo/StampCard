//
//  Shops.swift
//  StampCard
//
//  Created by Tsuneo Ootoshi on 2018/01/26.
//  Copyright © 2018年 Tsuneo Ootoshi. All rights reserved.
//

import UIKit

class Shops: Codable {
    let shopName : String
    let stampCount : String
    let shopId : String
    
    init(shopName : String, stampCount : String, shopId : String){
        self.shopName = shopName
        self.stampCount = stampCount
        self.shopId = shopId
    }
}
