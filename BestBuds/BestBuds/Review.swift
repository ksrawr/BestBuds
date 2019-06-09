//
//  Review.swift
//  BestBuds
//
//  Created by Khoi Dao on 5/14/19.
//  Copyright © 2019 An Dao & Kenneth Surban. All rights reserved.
//

import Foundation

class Review {
    var username: String
    var content: String
    var date: String
    
    init(username: String, content: String, date: String) {
        self.username = username
        self.content = content
        self.date = date
    }
}
