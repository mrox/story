//
//  Chapter.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 21/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import RealmSwift

class Chapter: Object {
    
    dynamic var book = 0
    dynamic var chapter = 0
    dynamic var createdAt : String!
    dynamic var id = 0
    dynamic var name : String!
    dynamic var story_id = 0
    dynamic var created_at : String!
    dynamic var updated_at : String!
    
    dynamic var story : Story?
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
