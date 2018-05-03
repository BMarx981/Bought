//
//  TripModel.swift
//  Bought
//
//  Created by Marx, Brian on 2/7/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit

class TripModel {
    var name = ""
    var receipes = [Item]()
    var totalPrice = 0.0
    var ailse = [String: [Item]]()
    
    func convertToItems(_ items: [String]) -> [Item] {
        var list = [Item]()
        for string in items {
            let itemObj = Item()
            itemObj.name = string
            list.append(itemObj)
        }
        return list
    }
}
