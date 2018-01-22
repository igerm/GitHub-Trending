//
//  Repository.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import ObjectMapper

final class Repository: Mappable {
    
    var name: String?
    var projectDescription: String?
    var authorUsername: String?
    var authorProfileImageURLString: String?
    var starsCount: Int = 0
    var forksCount: Int = 0
    var rank: Int = 0
    var urlString: String?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        name <- map["name"]
        projectDescription <- map["description"]
        authorUsername <- map["owner.login"]
        authorProfileImageURLString <- map["owner.avatar_url"]
        starsCount <- map["stargazers_count"]
        forksCount <- map["forks"]
        urlString <- map["html_url"]
    }
}

