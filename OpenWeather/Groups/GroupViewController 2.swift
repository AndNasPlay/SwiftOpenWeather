//
//  CityViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 13.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    @IBOutlet weak var groupTableView: UITableView!
    
    var ALLGroupsInfo = [
        groupProfile(type: .moto, category: "Street", name: "Ktm", groupImg: UIImage(named: "ktm.png")!, addGroup: .notAppend),
        groupProfile(type: .auto, category: "Street", name: "BMW", groupImg: UIImage(named: "bmw.png")!, addGroup: .notAppend),
        groupProfile(type: .auto, category: "Money", name: "Mercedes", groupImg: UIImage(named: "mercedes.png")!, addGroup: .notAppend),
        groupProfile(type: .moto, category: "Touring", name: "Honda", groupImg: UIImage(named: "honda.png")!, addGroup: .notAppend),
        groupProfile(type: .business, category: "HardMoney", name: "Chisto Kristo", groupImg: UIImage(named: "chistokristo.png")!, addGroup: .notAppend),
        groupProfile(type: .business, category: "EasyMoney", name: "Успешный успех", groupImg: UIImage(named: "successfulsuccess.png")!, addGroup: .notAppend)
    ]
    
    private var filteredGroups = [groupProfile]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "groupSegue",
            let cell = sender as? Groups,
            let destination = segue.destination as? GroupCardViewController
        {
            var GroupFilteredArr : [groupProfile]
            if isFiltering {
                GroupFilteredArr = filteredGroups
            } else {
                GroupFilteredArr = ALLGroupsInfo
            }
            destination.groupName = cell.titleLable.text
            destination.groupImage = cell.imageGroupTitle
            var needType: String = "Ошибка Type"
            var needCategory: String = "Ошибка Category"
           
            for i in 0...GroupFilteredArr.count {
                if cell.titleLable.text == GroupFilteredArr[i].name {
                    needType = GroupFilteredArr[i].type.rawValue
                    needCategory = GroupFilteredArr[i].category
                    break
                }
                else {
                    needType = "Ошибка2"
                }
            }
            destination.groupType = needType
            destination.groupCategory = needCategory
        }
    }
}


extension GroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredGroups.count
        }
        return ALLGroupsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group = groupTableView.dequeueReusableCell(withIdentifier: "Groups") as? Groups else { fatalError() }
        var GroupNew: groupProfile
        if isFiltering {
            GroupNew = filteredGroups[indexPath.row]
        } else {
            GroupNew = ALLGroupsInfo[indexPath.row]
        }
        group.titleLable.text = GroupNew.name
        group.imageGroupTitle.image = GroupNew.groupImg

        
        return group
    }
}

extension GroupViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        filteredGroups =  ALLGroupsInfo.filter({ (Groups: groupProfile) -> Bool in
            return Groups.name.lowercased().contains(searchText.lowercased())
        })
        groupTableView.reloadData()
    }
}
