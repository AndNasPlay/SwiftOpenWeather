//
//  NetworkManager.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 16.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class NetworkService {
    static let shared = NetworkService()

    enum NetworkError: Error {
        case incorrectData
    }
    
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
    
    private var session: URLSession {
        return URLSession.shared
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
                self.saveGroupsData(groupTest)
                print(groupTest[0].name)
            }
            catch {
                print(error)
            }
        }
    }
    func loadUsers(userId: Int, token: String, completion: @escaping (Result<[FriendsItems], NetworkError>) -> Void) {
        let params: Parameters = [
            "access_token": userId,
            "user_id": token,
            "order": "random",
            "v": version,
            "fields": "nickname",
            "count": 40
        ]
        AF.request(baseUrl + Methods.friends.rawValue, method: .get, parameters: params).responseData {  response in
            guard let data = response.data, let vkFriends = try? JSONDecoder().decode(FriendsInfo.self, from: data).response.items else {
                completion(.failure(.incorrectData))
                return
            }
            completion(.success(vkFriends))
        }.resume()
    }
    func loadVkFriends(userId: Int, token: String, completion: @escaping (Result<[FriendsItems], NetworkError>) -> Void) {
        let params: Parameters = [
            "access_token": userId,
            "user_id": token,
            "order": "random",
            "v": version,
            "fields": "nickname",
            "count": 40
        ]
        AF.request(baseUrl + Methods.friends.rawValue, method: .get, parameters: params).responseData { response in
            guard let data = response.data,
            let vkFriends = try? JSONDecoder().decode(FriendsInfo.self, from: data).response.items else {
                completion(.failure(.incorrectData))
                return
            }
            completion(.success(vkFriends))
        }.resume()
        
    }
    
    func loadFriends(userId: Int, token: String, completion: ((Result<[FriendsItems], Error>) -> Void)? = nil) {
        let params: Parameters = [
            "access_token": token,
            "user_id": userId,
            "order": "random",
            "v": version,
            "fields": "nickname",
            "count": 40
        ]
        
        AF.request(baseUrl + Methods.friends.rawValue, method: .get, parameters: params).responseData {
            response in
            guard let data = response.value else { return }
            do {
                let friends = try JSONDecoder().decode(FriendsInfo.self, from: data).response.items
                completion?(.success(friends))
                self.saveFriendsData(friends)
            }
            catch {
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }.resume()
    }
    
    func saveFriendsData(_ friends: [FriendsItems]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            realm.add(friends)
            try realm.commitWrite()
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm error")
        } catch {
            print(error)
        }
    }
    func saveGroupsData(_ groups: [GroupsItems]) {
        do {
            let realm = try Realm()
            //            if realm.isEmpty {
            realm.beginWrite()
            realm.add(groups)
            try realm.commitWrite()
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm error")
            //            } else  {
            //                try! realm.write {
            //                    realm.add(groups, update: .modified)
            //
            //                }
            //            }
        } catch {
            print(error)
        }
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
                print(photos[0].id, photos[0].ownerId, photos[0].sizes)
                self.savePhotoData(photos)
            }
            catch {
                print(error)
            }
        }
    }
    func savePhotoData(_ photo: [PhotoItems]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(photo)
            try realm.commitWrite()
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm error")
        } catch {
            print(error)
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

