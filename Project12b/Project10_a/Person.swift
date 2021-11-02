//
//  Person.swift
//  Project10_a
//
//  Created by 장선영 on 2021/11/01.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}

