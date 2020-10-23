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
import SwiftyJSON


class NetworkService {
    static let shared = NetworkService()
    
    enum NetworkError: Error {
        case incorrectData
    }
    
    private let baseUrl: String = "https://api.vk.com"
    private let testurl: String = "https://api.vk.com/method/newsfeed.get"
    private let version: String = "5.124"
    private var method: Methods?
    
    enum Methods: String {
        case groups = "/method/groups.get"
        case friends = "/method/friends.get"
        case photos = "/method/photos.get"
        case groupsSearch = "/method/groups.search"
        case news = "/method/newsfeed.get"
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
    
    func loadGroups(token: String, completion: ((Result<[GroupsItems], Error>) -> Void)? = nil) {
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "fields": "photo_100, type",
            "v": version
        ]
        AF.request(baseUrl + Methods.groups.rawValue, method: .get, parameters: params).responseData {
            response in
            guard let data = response.value else { return }
            do {
                let groups = try JSONDecoder().decode(GroupsInfo.self, from: data).response.items
                completion?(.success(groups))
                self.saveGroupsData(groups)
            }
            catch {
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }.resume()
    }
    
    func loadFriends(userId: Int, token: String, completion: ((Result<[FriendsItems], Error>) -> Void)? = nil) {
        let params: Parameters = [
            "access_token": token,
            "user_id": userId,
            "order": "random",
            "v": version,
            "fields": "photo_100",
            "count": 100
        ]
        
        AF.request(baseUrl + Methods.friends.rawValue, method: .get, parameters: params).responseData {
            response in
            AF.request(self.baseUrl + Methods.friends.rawValue, method: .get, parameters: params)
            guard let data = response.value else { return }
            do {
                let friends = try JSONDecoder().decode(FriendsInfo.self, from: data).response.items
                completion?(.success(friends))
                self.saveFriendsData(friends)
                print(Realm.Configuration.defaultConfiguration.fileURL)
            }
            catch {
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }.resume()
    }
    
    //    func loadNews(userId: Int, token: String, completion: ((Result<[Group], Error>) -> Void)? = nil) {
    //        let params: Parameters = [
    //            "access_token": token,
    //            "user_id": userId,
    //            "v": version,
    //            "filters": "post,photo,wall_photo,note",
    //            "count": 20,
    //            "scope": "friends, wall"
    //        ]
    //
    //        AF.request(baseUrl + Methods.news.rawValue, method: .post, parameters: params).responseData {
    //            response in
    //            guard let data = response.value else { return }
    //            do {
    ////                let newsItems: [Item] = try JSONDecoder().decode(NewsInfo.self, from: data).response.items
    ////                let newsProfiles: [Profile] = try JSONDecoder().decode(NewsInfo.self, from: data).response.profiles
    //                let newsGroups: [Group] = try JSONDecoder().decode(NewsInfo.self, from: data).response.groups
    //
    //                completion?(.success(newsGroups))
    //                print(Realm.Configuration.defaultConfiguration.fileURL)
    //                self.saveNewsData(newsGroups: newsGroups)
    //            }
    //            catch {
    //                print(error.localizedDescription)
    //                completion?(.failure(error))
    //            }
    //        }.resume()
    //    }
    
    //    func newsRequest(startFrom: String = "",
    //                     startTime: Double? = nil,
    //                     completion: @escaping (Swift.Result<[Response], Error>, String) -> Void) {
    //
    //        let path = "/method/newsfeed.get"
    //        var params: Parameters = [
    //            "access_token": Session.instanse.token,
    //            "filters": "post",
    //            "v": version,
    //            "count": "2",
    //            "start_from": startFrom
    //        ]
    //
    //        if let startTime = startTime {
    //            params["start_time"] = startTime
    //        }
    //
    //        AF.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
    //            switch response.result {
    //            case .failure(let error):
    //                completion(.failure(error), "")
    //            case .success(let value):
    //                let json = JSON(value)
    //                var friends = [profiles]()
    //                var groups = [groups]()
    //                let nextFrom = json["response"]["next_from"].stringValue
    //
    //                let parsingGroup = DispatchGroup()
    //                DispatchQueue.global().async(group: parsingGroup) {
    //                    friends = json["response"]["profiles"].arrayValue.map { Friend(json: $0) }
    //                }
    //                DispatchQueue.global().async(group: parsingGroup) {
    //                    groups = json["response"]["groups"].arrayValue.map { Group(json: $0) }
    //                }
    //                parsingGroup.notify(queue: .global()) {
    //                    let news = json["response"]["items"].arrayValue.map { NewsItem(json: $0) }
    //
    //                    news.forEach { newsItem in
    //                        if newsItem.sourceId > 0 {
    //                            let source = friends.first(where: { $0.id == newsItem.sourceId })
    //                            newsItem.source = source
    //                        } else {
    //                            let source = groups.first(where: { $0.id == -newsItem.sourceId })
    //                            newsItem.source = source
    //                        }
    //                    }
    //                    DispatchQueue.main.async {
    //                        completion(.success(news), nextFrom)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func loadVKNewsFeed(completion: @escaping (Swift.Result<String?, Error>) -> Void) {
        let params: Parameters = [
            "access_token": Session.instanse.token,
            "scope": "friends,photos,wall,groups",
            "v": version,
            "count": "10",
            //"start_from": startFrom
        ]
        
        
        NetworkService.session.request(baseUrl + Methods.news.rawValue, method: .get, parameters: params).responseData { response in
            print(NetworkService.session.request(self.baseUrl + Methods.news.rawValue, method: .get, parameters: params))
            
            switch response.result {
            case .failure(let error ):
                completion(.failure(error))
            case .success(let value):
                guard let Data = response.data else { return }
                let newsVk = try! JSONDecoder().decode(VkNews.self, from: Data).response.groups
                print(newsVk.count ?? "пусто")
                let nextFrom = try? JSONDecoder().decode(VkNews.self, from: Data).response.nextFrom
                completion(.success(nextFrom))
            }
        }
        
        //        AF.request(testurl, method: .get, parameters: params).responseJSON { response in
        //            print("one")
        //            print(AF.request(self.testurl, method: .get, parameters: params))
        //            switch response.result {
        //            case .failure(let error):
        //                completion(.failure(error))
        //            case .success(let value):
        //                let json = JSON(value)
        //                var news = [Item]()
        //                var users = [Profile]()
        //                var groups = [Group]()
        //                var nextFrom = ""
        ////                news = json["response"]["items"].array
        ////                users = json["response"]["profiles"].arrayValue.map { Profile(json: $0) }
        ////                groups = json["response"]["groups"].arrayValue.map { Group(json: $0) }
        //                nextFrom = json["response"]["next_from"].stringValue
        //
        //                //let news = VkNews(items: news, profiles: users, groups: groups)
        //                completion(.success(nextFrom), nil)
        //
        //            }
        //        }
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
        } catch {
            print(error)
        }
    }
    
    //    func saveNewsData(newsGroups:[Group]) {
    //        do {
    //            let realm = try Realm()
    //            realm.beginWrite()
    //            realm.deleteAll()
    //            realm.add(newsGroups)
    //            try realm.commitWrite()
    //            print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm error")
    //        } catch {
    //            print(error)
    //        }
    //    }
    
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

