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
            groupTableView.delegate = self
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
    
    private var filteredGroupsNotificationToken: NotificationToken?
    
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
    private var filteredGroups: Results<GroupsItems>?  {
        guard !searchText.isEmpty else { return vkGroups }
        return vkGroups?.filter("name CONTAINS[cd] %@", searchText)
        
    }
    private var searchText: String {
        searchController.searchBar.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredGroupsNotificationToken = filteredGroups?.observe { [weak self ] change in
            switch change {
            case let .initial(vkGroups):
                print("Initialized \(vkGroups.count)")
                
            case let .update(vkGroups, deletions: deletions, insertions: _, modifications: _):
                print("""
                    New count - \(vkGroups.count)
                    Deletions: \(deletions)
                    """)
                self?.groupTableView.reloadData()

            case let .error(Error):
                print("Ошибка")
            }
            
        }
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
    deinit {
        filteredGroupsNotificationToken?.invalidate()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "groupSegue",
            let cell = sender as? Groups,
            let destination = segue.destination as? GroupCardViewController
        {
            destination.groupName = cell.titleLable.text
            
            for i in 0...filteredGroups!.count {
                if cell.titleLable.text == filteredGroups?[i].name {
                    destination.groupImage = String(filteredGroups![i].groupImg)
                    destination.groupType = filteredGroups?[i].type
                    break
                }
                
            }
        }
    }
}


extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredGroups?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group = groupTableView.dequeueReusableCell(withIdentifier: "Groups") as? Groups else { fatalError() }
        
        let groupModel = filteredGroups?[indexPath.item]
        group.groupsModel = groupModel
        
        return group
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let vkGroup = filteredGroups?[indexPath.item] else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            try? self.realmManager?.delete(object: vkGroup)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
