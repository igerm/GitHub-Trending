//
//  Extensions.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import Foundation

extension Bundle {
    
    class var baseUrlString: String {
        return Bundle.main.infoDictionary?["API_BASE_URL"] as? String ?? ""
    }
    
    class var gitHubDailyTrendingURLString: String {
        return Bundle.main.infoDictionary?["GITHUB_DAILY_TRENDING_URL"] as? String ?? ""
    }
    
    class var gitHubPersonalTokenString: String {
        return Bundle.main.infoDictionary?["GITHUB_PERSONAL_TOKEN"] as? String ?? ""
    }
}
