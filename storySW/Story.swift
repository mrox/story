//
//  Story.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 21/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import RealmSwift
import ObjectMapper
import Alamofire
import SwiftyJSON


class Story: Object {
    
    dynamic var authorname : String!
    dynamic var cate : String!
    dynamic var chapter : String!
    dynamic var descriptionField : String!
    dynamic var download = 0
    dynamic var id = 0
    dynamic var imgurl : String!
    dynamic var like = 0
    dynamic var name : String!
    dynamic var number_chapters = 0
    dynamic var rate = 0
    dynamic var ratecount = 0
    dynamic var status : String!
    dynamic var updated_at : NSDate!
    dynamic var created_at : NSDate!
    dynamic var view = 0
//    dynamic var last_chapters : [AnyObject]?
    
    var chapters = List<Chapter>()
    
    
    
    required convenience init?(_ map: Map) {
        self.init()
        mapping(map)
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

extension Story : Mappable {
    func mapping(map: Map) {
        
        authorname <- map["authorname"]
        id <- map["id"]
        name <- map["name"]
        imgurl <- map["imgurl"]
        cate <- map["cate"]
        view <- map["view"]
        like <- map["like"]
        download <- map["download"]
        descriptionField <- map["description"]
        status <- map["status"]
        chapter <- map["chapter"]
        rate <- map["rate"]
        number_chapters <- map["number_chapters"]
        
        chapters <- map["last_chapters"]
        
        ratecount <- map["ratecount"]
        created_at <- (map["created_at"],StoryDateTransform())
        updated_at <- (map["updated_at"],StoryDateTransform())
    }
    
}

extension Story  {
    
    class func getNew( page currentPage: Int, complate:(result: [Story])-> Void){

        let API_URL = "http://ebook2.local.192.168.1.15.xip.io/api/story?page=\(currentPage)"
        
        Alamofire.request(.GET, API_URL).responseJSON { (responseData) -> Void in
            
            if (responseData.result.error != nil){
                return
            }
            
            let swiftyJsonVar = JSON(responseData.result.value!)
            let stories = swiftyJsonVar["data"].arrayObject
            var data = [Story]()
            for subJson in stories!{

                let story : Story = Mapper<Story>().map(subJson)!
                data.append(story)

            }
            complate(result: data)

        }
    }
}

class StoryDateTransform : DateTransform {
    override func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let dateStr = value as? String {
            return NSDate.dateWithString(
                dateStr,
                format: "yyyy-MM-DD HH:mm:ss", //"E, dd MMM yyyy HH:mm:ss zzzz" ,//YYYY-MM-DD HH:MI:SS
                locale : NSLocale(localeIdentifier: "vi_VN"))
        }
        return nil
    }
}






















