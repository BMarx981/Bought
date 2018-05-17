//
//  Aisle.swift
//  Bought
//
//  Created by Marx, Brian on 5/7/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import Foundation

class Aisle {
    var name = ""
    var isExpanded = false
    var items = [Item]()
    
    init(){}
    
    init(name: String, list: [Item], expand: Bool) {
        self.name = name
        isExpanded = expand
        items = list
    }
}

extension Aisle: Equatable {
    static func ==(lhs: Aisle, rhs: Aisle) -> Bool {
        return lhs.name == rhs.name &&
            lhs.isExpanded == rhs.isExpanded
    }
}

extension Aisle: Hashable {
    var hashValue: Int {
        return name.hashValue ^ isExpanded.hashValue
    }
}

