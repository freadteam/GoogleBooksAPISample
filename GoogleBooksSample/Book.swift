//
//  Book.swift
//  GoogleBooksSample
//
//  Created by Ryo Endo on 2018/07/15.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit

class Book: NSObject {

    var title: String
    var authors: [String]?
    var summary: String?
    var categories: [String]?
    var previewLinkURL: String?
    var detailText: String?
    
    init(title: String) {
        self.title = title
    }
    
}
