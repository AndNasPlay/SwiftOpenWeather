//
//  News.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 05.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
import SDWebImage

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var NewsTitleimage: UIImageView!
    @IBOutlet weak var NewsText: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var likeCounts: UILabel!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var shear: UIButton!
    @IBOutlet weak var eyeCount: UILabel!
    @IBOutlet weak var dateTimeNews: UILabel!
    @IBOutlet weak var autorName: UILabel!
    
    var switcher: Int = 0
    var countLike: Int = 0
    
    var NewsItemModel: NewsItem? {
        didSet {
            setupItem()
        }
    }
    private func setupItem() {
        guard let NewsItemModel = NewsItemModel else { return }
        
        let NewsTitleimage1 = NewsItemModel.photos.first?.url
        let NewsText1 = NewsItemModel.text
        let likeCounts1 = String(NewsItemModel.likesCount)
        let eyeCount1 = String(NewsItemModel.viewsCount)
        let dateTimeNews1 = NewsItemModel.date
        
        
        NewsTitleimage.sd_setImage(with: NewsTitleimage1)
        NewsText.text = NewsText1
        likeCounts.text = likeCounts1
        eyeCount.text = eyeCount1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM в H:mm"
        var dateSting = dateFormatter.string(from: dateTimeNews1)
        dateTimeNews.text = dateSting
        autorName.text = "Сеня"
    }
    
    
    //    var NewsModel: NewsAllFeed? {
    //        didSet {
    //            setup()
    //        }
    //    }
    //
    //    private func setup() {
    //        guard let NewsModel = NewsModel else { return }
    //
    //        var NewsTitleimage1: URL?
    //        var NewsText1: String?
    //        var likeCounts1: String?
    //        var eyeCount1: String?
    //        var dateTimeNews1: Date?
    //
    //        for i in 0...NewsModel.newsItems.count - 1 {
    //            NewsTitleimage1 = NewsModel.newsItems[i].photos.first?.url
    //            NewsText1 = NewsModel.newsItems[i].text
    //            likeCounts1 = String(NewsModel.newsItems[i].likesCount)
    //            eyeCount1 = String(NewsModel.newsItems[i].viewsCount)
    //            dateTimeNews1 = NewsModel.newsItems[i].date
    //        }
    //
    //        NewsTitleimage.sd_setImage(with: NewsTitleimage1)
    //        NewsText.text = NewsText1
    //        likeCounts.text = likeCounts1!
    //        eyeCount.text = eyeCount1!
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "dd MMM в H:mm"
    //        var dateSting = dateFormatter.string(from: dateTimeNews1!)
    //        dateTimeNews.text = dateSting
    //        autorName.text = "Сеня"
    //    }
    
    
    
    
    @IBAction func likeControll(_ sender: UIButton) {
        if like.isTouchInside  && switcher == 0 {
            countLike += 1
            switcher += 1
            print(countLike)
            like.setImage(#imageLiteral(resourceName: "heartfill"), for: .normal)
        } else {
            countLike -= 1
            switcher -= 1
            print(countLike)
            like.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        }
        
    }
}





