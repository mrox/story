//
//  Chapter.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 21/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import RealmSwift
import ObjectMapper

class Chapter: Object {
    
    dynamic var book = 0
    dynamic var chapter = 0
    dynamic var id = 0
    dynamic var name : String!
    dynamic var story_id = 0
    dynamic var created_at : String!
    dynamic var updated_at : String!
    
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
        updated_at <- map["updated_at"]

    }
}
