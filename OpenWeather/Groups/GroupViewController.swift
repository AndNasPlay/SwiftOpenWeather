//
//  CityViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 13.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
import RealmSwift

class GroupViewController: UIViewController {
    
    @IBOutlet weak var groupTableView: UITableView! {
        didSet {
            groupTableView.dataSource = self
        }
    }
    
    private let realmManager = RealmManager.shared
    private let networkManager = NetworkService.shared
    
    private var tokenTry: String {
        Session.instanse.token
    }
    private var userIdTry: Int {
        Session.instanse.userId
    }
    
    private var vkGroups: Results<GroupsItems>? {
        let vkGroups: Results<GroupsItems>? = realmManager?.getObjects()
        return vkGroups?.sorted(byKeyPath: "id", ascending: true)
    }
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.loadGroups(token: tokenTry) { [weak self] result in
            switch result {
            case let .success(groups):
                DispatchQueue.main.async {
                    try? self?.realmManager?.add(objects: groups)
                    self?.groupTableView.reloadData()
                    completion?()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private var filteredGroups: [GroupsItems]? {
        guard !searchText.isEmpty else { return vkGroups != nil ? Array(vkGroups!) : [] }
        return vkGroups?.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        
    }
    private var searchText: String {
        searchController.searchBar.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vkGroups = vkGroups, vkGroups.isEmpty {
            loadData()
        }
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
            destination.groupName = cell.titleLable.text
            
            for i in 0...vkGroups!.count {
                if cell.titleLable.text == vkGroups?[i].name {
                    destination.groupImage = String(vkGroups![i].groupImg)
                    destination.groupType = vkGroups?[i].type
                    break
                }
                
            }
        }
    }
}


extension GroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredGroups?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group = groupTableView.dequeueReusableCell(withIdentifier: "Groups") as? Groups else { fatalError() }
        
        let groupModel = filteredGroups?[indexPath.item]
        group.groupsModel = groupModel
        
        return group
    }
}

extension GroupViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        var filteredGroups: Results<GroupsItems>? {
            if isFiltering {
                return vkGroups?.filter(NSPredicate(format: "name CONTAINS[cd] %@", searchText))
            } else {
                return vkGroups
            }
        }
        groupTableView.reloadData()
    }
}
