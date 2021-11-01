//
//  Person.swift
//  Project10_a
//
//  Created by 장선영 on 2021/11/01.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }

    func encode(with acoder: NSCoder) {
        acoder.encode(name, forKey: "name")
        acoder.encode(image, forKey: "image")
    }
    
    
}

