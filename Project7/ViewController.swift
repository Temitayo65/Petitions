//
//  ViewController.swift
//  Project7
//
//  Created by ADMIN on 10/09/2022.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        let creditBarItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(showCredit))
        let filterBarItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"),style: .plain, target: self, action: #selector(filterItems))
        navigationItem.rightBarButtonItems = [creditBarItem, filterBarItem]
        
        // print(filterBarItem.isSelected)
        // filterBarItem.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        showError()
        
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError(){
        let ac = UIAlertController(title:"Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPetitions.isEmpty{
            return petitions.count}
        else{
            return filteredPetitions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if filteredPetitions.isEmpty{
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
            return cell
        }
        else{
            let petition = filteredPetitions[indexPath.row]
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
            return cell
        }
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailItem = petitions[indexPath.row]
        let vc = DetailViewController()
        vc.detailItem = detailItem
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func showCredit(){
        let ac = UIAlertController(title: "Credit", message: "The data comes from:\n 'We The People API of the Whitehouse'.", preferredStyle: .alert)
        let creditAction = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(creditAction)
        present(ac, animated: true)
    }
    
    @objc func filterItems(){
        let ac = UIAlertController(title: "Filter by Title:", message: "Type in your filter word", preferredStyle: .alert)
        ac.addTextField()
        var filteredItems = [Petition]()
        let filterAction = UIAlertAction(title: "Filter", style: .default){[weak self, weak ac]
            _ in
           
            if let filterText = ac?.textFields?[0].text{
                for petition in self!.petitions {
                    if petition.title.contains(filterText){
                        filteredItems.append(petition)
                    }
                }
                self?.renewView(data: filteredItems)
            }
        }
        ac.addAction(filterAction)
        present(ac, animated: true)
    }
    
    func renewView(data: [Petition]){
        filteredPetitions = data
        if !filteredPetitions.isEmpty{
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
        }else{
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        }
        tableView.reloadData()
    }
    
}

