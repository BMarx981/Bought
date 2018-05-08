//
//  Ailse.swift
//  Bought
//
//  Created by Marx, Brian on 5/7/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import Foundation

class Ailse {
    var name = ""
    var isExpanded = false
    var items = [Item]()
    
    init(name: String, list: [Item], expand: Bool) {
        self.name = name
        isExpanded = expand
        items = list
    }
}

extension Ailse: Equatable {
    static func ==(lhs: Ailse, rhs: Ailse) -> Bool {
        return lhs.name == rhs.name &&
        lhs.isExpanded == rhs.isExpanded
    }
}

extension Ailse: Hashable {
    var hashValue: Int {
         return name.hashValue ^ isExpanded.hashValue
    }
}
