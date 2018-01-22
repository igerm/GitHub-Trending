//
//  RepositoryViewModel.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit

struct RepositoryViewModel {
    
    var name: String?
    var projectDescription: String?
    var authorUsername: String?
    var authorProfileImageURL: URL?
    var starsCount: String?
    var forksCount: String?
    var rank: Int
    var url: URL?
}

extension RepositoryViewModel {
    
    init(repository: Repository) {
        
        name = repository.name
        projectDescription = repository.projectDescription
        authorUsername = repository.authorUsername
        starsCount = "\(repository.starsCount)"
        forksCount = "\(repository.forksCount)"
        rank = repository.rank
        
        if let authorProfileImageURLString = repository.authorProfileImageURLString {
            authorProfileImageURL = URL(string: authorProfileImageURLString)
        }
        
        if let urlString = repository.urlString {
            url = URL(string: urlString)
        }
    }
}