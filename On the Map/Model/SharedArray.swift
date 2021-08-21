//
//  gg.swift
//  On the Map
//
//  Created by ابرار on ٢٧ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
class SharedArray {
    static let shared = SharedArray()
    
    var InfoArray = [Any?]()
    
    private init() { }
}
