//
//  Owner.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2020-11-10.
//  Copyright © 2020 Samuel Tremblay. All rights reserved.
//

final class Owner: Codable {

    enum CodingKeys: String, CodingKey {
        case username = "login"
        case profileImageURLString = "avatar_url"
    }

    var username: String?
    var profileImageURLString: String?
}
