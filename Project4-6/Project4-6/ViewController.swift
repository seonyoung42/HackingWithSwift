//
//  ViewController.swift
//  Project4-6
//
//  Created by 장선영 on 2021/09/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(refreshShoppingList))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShoppingList))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShoppingList))
        navigationItem.rightBarButtonItems = [addButton,shareButton]
        
        
        title = "Shopping List"
        
    }

    @objc func refreshShoppingList() {
        shoppingList = []
        self.tableView.reloadData()
    }
    
    @objc func addShoppingList() {
        let ac = UIAlertController(title: "Add ShoppingList", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitShoppingList = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
//            self?.shoppingList.append(answer)
//            self!.tableView.reloadData()
            self?.addItem(answer)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        ac.addAction(submitShoppingList)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func shareShoppingList() {
        let list = shoppingList.joined(separator: "\n")
        
        let atv = UIActivityViewController(activityItems: [list], applicationActivities: nil)
        atv.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(atv, animated: true, completion: nil)
        
    }
    
    func addItem(_ item: String) {
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Shopping", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }

}

