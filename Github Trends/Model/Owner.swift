//
//  Owner.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2020-11-10.
//  Copyright © 2020 Samuel Tremblay. All rights reserved.
//

import RealmSwift

final class Owner: Object, Codable {

    enum CodingKeys: String, CodingKey {
        case username = "login"
        case profileImageURLString = "avatar_url"
    }

    @objc dynamic var username: String?
    @objc dynamic var profileImageURLString: String?
}
