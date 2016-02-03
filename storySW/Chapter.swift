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
    
    dynamic var book = 0
    dynamic var chapter = 0
    dynamic var id = 0
    dynamic var name : String!
    dynamic var story_id = 0
    dynamic var created_at : NSDate!
    dynamic var updated_at : NSDate!
    
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
        updated_at <- (map["updated_at"],StoryDateTransform())
        created_at <- (map["created_at"],StoryDateTransform())

    }
}

extension Chapter {
    class func getList(storyID: Int, complate:(result: [Chapter])-> Void) {
        
        let API_URL = "http://ebook2.local.192.168.1.15.xip.io/api/story/\(storyID)/chapters"

        
        Alamofire.request(.GET, API_URL).responseJSON { (response) -> Void in
            
            if (response.result.error != nil){
                print(response.result.error?.description)
                return
            }
            
            let cachedURLResponse = NSCachedURLResponse(response: response.response!, data: (response.data! as NSData), userInfo: nil, storagePolicy: .Allowed)
            NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: response.request!)
            
            let swiftyJsonVar = JSON(response.result.value!)
            let chapters = swiftyJsonVar.arrayObject
            var data = [Chapter]()
            
            for subJson in chapters!{
                
                let chapter : Chapter = Mapper<Chapter>().map(subJson)!
                data.append(chapter)
                
            }
            complate(result: data)
            
        }
    }
}






