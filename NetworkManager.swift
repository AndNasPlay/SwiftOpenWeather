//
//  NetworkManager.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 16.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    private let baseUrl: String = "https://api.vk.com"
    private let version: String = "5.92"
    private var method: Methods?
    
    enum Methods: String {
        case groups = "/method/groups.get"
        case friends = "/method/friends.get"
        case photos = "/method/photos.get"
        case groupsSearch = "/method/groups.search"
    }
    
    enum AlbomID: String {
        case wall = "wall"
        case profile = "profile"
        case saved = "saved"
    }
    
    static let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
    
    func loadGroups(token: String) {
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": version
        ]
        AF.request(baseUrl + Methods.groups.rawValue, method: .get, parameters: params).responseData {
            response in
            guard let data = response.data else { return }
            do {
                let groupTest = try JSONDecoder().decode(GroupsInfo.self, from: data).response.items
                print(groupTest[0].name)
            }
            catch {
                print(error)
            }
        }
    }
    
    func loadFriends(userId: Int, token: String) -> [FriendsItems] {
        let params: Parameters = [
            "access_token": token,
            "user_id": userId,
            "order": "random",
            "v": version,
            "fields": "nickname",
            "count": "10"
        ]
        var friendsAllNew: [FriendsItems] = []
        AF.request(baseUrl + Methods.friends.rawValue, method: .get, parameters: params).responseData {
            response in
            guard let data = response.data else { return }
            do {
                let friends = try JSONDecoder().decode(FriendsInfo.self, from: data).response.items
                print(friends.first!.firstName, friends.first!.lastName )
                friendsAllNew = friends
            }
            catch {
                print(error)
            }
        }
        return friendsAllNew
        
    }
    
    func loadPhoto(userId: Int, token: String) {
        let params: Parameters = [
            "access_token": token,
            "owner_id": userId,
            "album_id": AlbomID.profile,
            "rev": "1",
            "count": "1",
            "v": version,
        ]
        AF.request(baseUrl + Methods.photos.rawValue, method: .get, parameters: params).responseData {
            response in
            guard let data = response.data else { return }
            do {
                let photos = try JSONDecoder().decode(PhotoInfo.self, from: data).response.items
                print(photos[0].id, photos[0].ownerId)
            }
            catch {
                print(error)
            }
        }
    }
    func groupsSearch(token: String, searchText: String) {
        let params: Parameters = [
            "access_token": token,
            "q": searchText,
            "type": "group",
            "count": "1",
            "v": version
        ]
        NetworkService.session.request(baseUrl + Methods.groupsSearch.rawValue, method: .get, parameters: params).responseData { response in
            guard let data = response.data else { return }
            do {
                let groupSearch = try JSONDecoder().decode(GroupsInfo.self, from: data).response.items
                print(groupSearch[0].name)
            }
            catch {
                print(error)
            }
            
        }
    }
}

