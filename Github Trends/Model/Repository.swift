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
    
    @objc dynamic var name: String?
    @objc dynamic var fullName: String?
    @objc dynamic var projectDescription: String?
    @objc dynamic var starsCount: Int = 0
    @objc dynamic var forksCount: Int = 0
    @objc dynamic var rank: Int = 0
    @objc dynamic var urlString: String?
    @objc dynamic var owner: Owner?
}
