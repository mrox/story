//
//  ArrayTransform.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 25/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import RealmSwift

class ListTransform<T:RealmSwift.Object where T:Mappable> : TransformType {
    typealias Object = List<T>
    typealias JSON = [AnyObject]
    
    let mapper = Mapper<T>()
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        let results = List<T>()
        if let value = value as? [AnyObject] {
            for json in value {
                if let obj = mapper.map(json) {
                    results.append(obj)
                }
            }
        }
        return results
    }
    
    
    func transformToJSON(value: Object?) -> JSON? {
        var results = [AnyObject]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json)
            }
        }
        return results
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