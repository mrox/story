//
//  Chapter.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 21/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import RealmSwift
import ObjectMapper
import Alamofire
import SwiftyJSON


class Chapter: Object {
    
    dynamic var book: String!
    dynamic var chapter: String!
    dynamic var id: String!
    dynamic var name : String!
    dynamic var story_id: String!
    dynamic var created_at : String!
    dynamic var nextChapter: String!
    dynamic var prevChapter: String!
    dynamic var haveimg: String!
    dynamic var content: String!
//    dynamic var updated_at : NSDate!
    
    dynamic var story : Story?
    

    required convenience init?(_ map: Map) {
        self.init()
        mapping(map)
    }
    
    override class func primaryKey() -> String {
        return "id"
    }

}

extension Chapter : Mappable {
    func mapping(map: Map) {
        
        id <- map["id"]
        chapter <- map["chapter"]
        name <- map["name"]
        nextChapter <- map["nextchapter"]
        prevChapter <- map["prevchapter"]
        created_at <- map["dateup"]
        story_id <- map["storyid"]
        book <- map["book"]
        content <- map["content"]
        haveimg <- map["haveimg"]
    }
}

extension Chapter {
    class func getList(storyID: Int, complate:(result: [Chapter])-> Void) {
        
//        let API_URL = "http://ebook2.local.192.168.1.15.xip.io/api/story/\(storyID)/chapters"
        let API_URL = "http://webtruyen.com/api3/getlistchapter?id=\(storyID)&perpage=20000&page=1"
        
        
        Alamofire.request(.GET, API_URL).responseJSON { (response) -> Void in
            
            if (response.result.error != nil){
                print(response.result.error?.description)
                return
            }
            
            let cachedURLResponse = NSCachedURLResponse(response: response.response!, data: (response.data! as NSData), userInfo: nil, storagePolicy: .Allowed)
            NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: response.request!)
            
            let swiftyJsonVar = JSON(response.result.value!)
            let chapters = swiftyJsonVar["book"].arrayObject
            print(chapters)

            var data = [Chapter]()
            
            for subJson in chapters!{
                
                let chapter : Chapter = Mapper<Chapter>().map(subJson)!
                data.append(chapter)
                
            }
            
            print(data)

            complate(result: data)
            
        }
    }
    
    class func getContent(chapterID: String, complate:(result: Chapter)-> Void) {
        let API_URL = "http://webtruyen.com/api3/chapter?id=\(chapterID)"
        
        Alamofire.request(.GET, API_URL).responseJSON { (response) -> Void in
            
            if (response.result.error != nil){
                print(response.result.error?.description)
                return
            }
            
            let cachedURLResponse = NSCachedURLResponse(response: response.response!, data: (response.data! as NSData), userInfo: nil, storagePolicy: .Allowed)
            NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: response.request!)
            
            let swiftyJsonVar = JSON(response.result.value!)
            let chapters = swiftyJsonVar["book"][0].object
            let chapter: Chapter = Mapper<Chapter>().map(chapters)!
            
            complate(result: chapter)
            
        }
    }
}






