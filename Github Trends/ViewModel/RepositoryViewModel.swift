//
//  RepositoryViewModel.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit
import SVProgressHUD

final class RepositoryViewModel: HasRepositoryService {
    
    private var repository: Repository {
        didSet {
            modelUpdated?(self)
        }
    }
    
    var modelUpdated:((_ model: RepositoryViewModel)->())?
    
    var name: String?
    var projectDescription: String?
    var authorUsername: String?
    var authorProfileImageURL: URL?
    var starsCount: String?
    var forksCount: String?
    var rank: Int
    var url: URL?
    var readmeString: String? {
        didSet {
            modelUpdated?(self)
        }
    }
    
    init(repository: Repository) {
        
        self.repository = repository
        
        name = repository.name
        projectDescription = repository.projectDescription
        authorUsername = repository.authorUsername
        starsCount = "\(repository.starsCount) \(NSLocalizedString("Stars", comment: ""))"
        forksCount = "\(repository.forksCount) \(NSLocalizedString("Forks", comment: ""))"
        rank = repository.rank
        
        if let authorProfileImageURLString = repository.authorProfileImageURLString {
            authorProfileImageURL = URL(string: authorProfileImageURLString)
        }
        
        if let urlString = repository.urlString {
            url = URL(string: urlString)
        }
    }
    
    func refreshData() {
        
        SVProgressHUD.show()
        repositoryService?.retrieveReadme(repository: repository, completion: { [weak self] (readmeString) in
            
            self?.readmeString = readmeString
            SVProgressHUD.dismiss()
        })
    }
}
