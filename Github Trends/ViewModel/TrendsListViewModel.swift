//
//  TrendsListViewModel.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit

struct TrendsListViewModel {
    
    var title: String? = NSLocalizedString("GitHub Trends", comment: "")
    var repositories: [RepositoryViewModel] = [RepositoryViewModel]()
}

extension TrendsListViewModel {
    
    init(repositories: [RepositoryViewModel]) {
        
        self.repositories = repositories
    }
}
