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
    
    @IBOutlet weak var searchTextField: UISearchBar!
    
    private let realmManager = RealmManager.shared
    private let networkManager = NetworkService.shared
    private var tokenTry: String {
        Session.instanse.token
    }
    private var userIdTry: Int {
        Session.instanse.userId
    }

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
    
    private var filteredvkFriends: Results<FriendsItems>? {
        guard !searchText.isEmpty else { return vkFriends }
        return vkFriends?.filter(NSPredicate(format: "firstName CONTAINS[cd] %@", searchText))
    }
    private var searchText: String {
        searchTextField.text ?? ""
    }
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.loadFriends(userId: userIdTry, token: tokenTry) { [weak self] result in
            switch result {
            case let .success(friends):
                
                DispatchQueue.main.async {
                    try? self?.realmManager?.add(objects: friends)
                    self?.tableView.reloadData()
                    completion?()
                }
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vkFriends = vkFriends, vkFriends.isEmpty {
            loadData()
        }
        tableView.dataSource = self
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            if segue.identifier == "frendSegue",
                let frend = sender as? Frends,
                let destination = segue.destination as? frendCardViewController {
                destination.frendName = frend.titleLable.text
                //destination.frendAvatar = frend.imageLable
                for i in 0...vkFriends!.count {
                    if frend.titleLable.text == filteredvkFriends?[i].firstName {
                        destination.friendlastName = String(filteredvkFriends?[i].lastName ?? "Дима")
                        //destination.frendAge = Int(filteredvkFriends?[i].id)
                        break
                    }
                    else {
                        print("Ошибка")
                    }
                }
            }
    
        }
    
}
extension FrendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredvkFriends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let friend = tableView.dequeueReusableCell(withIdentifier: "Frends") as? Frends else { fatalError() }
        friend.titleLable.text = filteredvkFriends?[indexPath.item].firstName
        friend.SurName.text = filteredvkFriends?[indexPath.item].lastName
        return friend
    }
    
    
}



//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let vkFriend = vkFriends?[indexPath.item] else { return }
//        if (try? realmManager?.delete(object: vkFriend)) != nil {
//            tableView.deleteRows(at: [indexPath], with: .right)
//        }
//    }


//extension FrendsViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return vkFriends?.count ?? 0
//            //sections[section].names.count
//
//    }
//
////    func numberOfSections(in tableView: UITableView) -> Int {
////        return sections.count
////
////    }
//
////    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
////        return sections.map{$0.letter}
////
////    }
//
//
//
////    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////
////        return sections[section].letter
////
////    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let frend = tableView.dequeueReusableCell(withIdentifier: "Frends") as? Frends else { fatalError() }
////        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////
////            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserInfoTableViewCell.self), for: indexPath) as! UserInfoTableViewCell
////
////            let userModel = filteredUsers?[indexPath.item]
////            cell.userModel = userModel
////
////            return cell
////        }
////
////        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////            guard let user = filteredUsers?[indexPath.item] else { return }
////            if (try? realmManager?.delete(object: user)) != nil {
////                tableView.deleteRows(at: [indexPath], with: .right)
////            }
////        }
//
//        //let friendsNewAll: [FriendsItems] = NetworkService.shared.loadFriends(userId: Session.instanse.userId, token: Session.instanse.token)
//        let friendsModel = vkFriends?[indexPath.item]
//        frend.friendsModel = friendsModel
//        //frend.imageLable.image = allFrends.first?.avatar
//
//            //friendsNewAll[indexPath.section].firstName
////            + friendsNewAll[indexPath.section].lastName
//        //frend.SurName.text = vkFriends?[indexPath.item].lastName
//        return frend
//
//
//    }
//


