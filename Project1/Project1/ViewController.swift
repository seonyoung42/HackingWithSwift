//
//  ViewController.swift
//  Project1
//
//  Created by 장선영 on 2021/09/01.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global().async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath! // tells me where i can find all those images i added to my app
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    // this is a picture to load
                    self.pictures.append(item)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
//        let fm = FileManager.default
//        let path = Bundle.main.resourcePath! // tells me where i can find all those images i added to my app
//        let items = try! fm.contentsOfDirectory(atPath: path)
//
//        for item in items {
//            if item.hasPrefix("nssl") {
//                // this is a picture to load
//                pictures.append(item)
//            }
//        }
        
        print(pictures)
        self.pictures.sort()
        print(pictures)

    }
    
    func sortArray() {
        self.pictures.sort()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture",for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.totalImage = pictures.count
            vc.selectedIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

