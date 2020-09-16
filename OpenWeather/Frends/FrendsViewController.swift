//
//  CityViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 13.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
import RealmSwift

class FrendsViewController: UIViewController {
    
    private let realmManager = RealmManager.shared
    private let networkManager = NetworkService.shared
    private var tokenTry: String {
        Session.instanse.token
    }
    private var userIdTry: Int {
        Session.instanse.userId
    }
    
    private var filteredUsersNotificationToken: NotificationToken?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var vkFriends: Results<FriendsItems>? {
        let vkFriends: Results<FriendsItems>? = realmManager?.getObjects()
        return vkFriends?.sorted(byKeyPath: "id", ascending: true)
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.loadFriends(userId: userIdTry, token: tokenTry) { [weak self] result in
            switch result {
            case let .success(friends):
                DispatchQueue.main.async {
                    try? self?.realmManager?.add(objects: friends)
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
    private var filteredUsers: Results<FriendsItems>? {
        guard !searchText.isEmpty else { return vkFriends }
        return vkFriends?.filter("firstName CONTAINS[cd] %@", searchText)
        
    }
    private var searchText: String {
        searchController.searchBar.text ?? ""
    }
                    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredUsersNotificationToken = filteredUsers?.observe { [weak self ] change in
            switch change {
            case let .initial(vkFriends):
                print("Initialized \(vkFriends.count)")
                
            case let .update(vkFriends, deletions: deletions, insertions: _, modifications: _):
                print("""
                    New count - \(vkFriends.count)
                    Deletions: \(deletions)
                    """)
                self?.tableView.reloadData()
                //                self?.tableView.beginUpdates()
                //
                //                self?.tableView.deleteRows(at: deletions.map {IndexPath(item: $0, section: 0)},
                //                                           with: .automatic)
                //                self?.tableView.insertRows(at: insertions.map {IndexPath(item: $0, section: 0)},
                //                                           with: .automatic)
                //                self?.tableView.endUpdates()
                
            case let .error(Error):
                print("Ошибка")
            }
            
        }
        
        if let vkFriends = vkFriends, vkFriends.isEmpty {
            loadData()
        }
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    deinit {
        filteredUsersNotificationToken?.invalidate()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "frendSegue",
            let frend = sender as? Frends,
            let destination = segue.destination as? frendCardViewController {
            destination.frendName = frend.titleLable.text
            for i in 0...filteredUsers!.count {
                if frend.titleLable.text == filteredUsers?[i].firstName && frend.friendsModel?.lastName == filteredUsers?[i].lastName {
                    destination.friendlastName = String(filteredUsers?[i].lastName ?? "Дима")
                    destination.frendAvatar = String(filteredUsers![i].avatarFriend)
                    break
                }
            }
        }
    }
}
extension FrendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let friend = tableView.dequeueReusableCell(withIdentifier: "Frends") as? Frends else { fatalError() }
        
        let friendModel = filteredUsers?[indexPath.item]
        friend.friendsModel = friendModel
        return friend
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let vkFriend = filteredUsers?[indexPath.item] else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            try? self.realmManager?.delete(object: vkFriend)
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
extension FrendsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        var filteredUsers: Results<FriendsItems>? {
            if isFiltering {
                return vkFriends?.filter(NSPredicate(format: "firstName CONTAINS[cd] %@", searchText))
            } else {
                return vkFriends
            }
        }
        tableView.reloadData()
    }
}
