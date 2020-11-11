//
//  Repository.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import RealmSwift

final class Repository: Object, Codable {

    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case projectDescription = "description"
        case starsCount = "stargazers_count"
        case forksCount = "forks"
        case urlString = "html_url"
        case owner
    }
    
    var name: String?
    var fullName: String?
    var projectDescription: String?
    var starsCount: Int = 0
    var forksCount: Int = 0
    var rank: Int = 0
    var urlString: String?
    var owner: Owner?
}
