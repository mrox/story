//
//  String2Html.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 03/02/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit

extension String {
    
    var html2AttributedString: NSMutableAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            
            return try NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


