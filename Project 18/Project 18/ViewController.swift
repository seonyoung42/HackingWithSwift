//
//  ViewController.swift
//  Project 18
//
//  Created by 장선영 on 2021/11/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I'm inside the viewDidLoad method")
        print(1,2,3,4,5, separator: "-")
        print("some message",terminator: "")
        
        assert(1==1, "math failure!(1)")
//        assert(1==2, "math failure!(2)")
        
        for i in 1...100 {
            print("Got number \(i).")
        }
    }


}

