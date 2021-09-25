//
//  ViewController.swift
//  Project7
//
//  Created by 장선영 on 2021/09/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
    }
    
    
    // storyboard의 viewController들은 viewWillAppear 메서드가 호출된 이후 로드된다. 따라서 viewDidLoad에서 navigationBar는 nil이다.
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(alertData))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterData))
    }
    
    
    @objc func alertData() {
        let ac = UIAlertController(title: "Data source", message: "This is from 'We The People API of the Whitehouse'", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    @objc func filterData() {
        let ac = UIAlertController(title: "Filter petitions", message: "Type into filter..", preferredStyle: .alert)
        ac.addTextField()
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) { _ in
            guard let filterWord = ac.textFields?[0].text else { return }
            self.showPetitions(for: filterWord)
            
        }
        ac.addAction(filterAction)
        present(ac, animated: true, completion: nil)
    }
    
    
    func showPetitions(for filter: String) {
        filteredPetitions = []
        
        for petition in petitions {
            if petition.title.contains(filter) || petition.body.contains(filter) {
                filteredPetitions.append(petition)
            }
        }
        
        tableView.reloadData()
    }
    
    
    func showError() {
        let ac = UIAlertController(title: "Lodaing error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPetitions.isEmpty {
            return petitions.count
        } else {
            return filteredPetitions.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        let petition = petitions[indexPath.row]
        
        if filteredPetitions.isEmpty {
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
        } else {
            let filterdPetition = filteredPetitions[indexPath.row]
            cell.textLabel?.text = filterdPetition.title
            cell.detailTextLabel?.text = filterdPetition.body
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        if filteredPetitions.isEmpty {
            vc.detailItem = petitions[indexPath.row]
        } else {
            vc.detailItem = filteredPetitions[indexPath.row]
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

