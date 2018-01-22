//
//  TrendsListViewModel.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit
import SVProgressHUD

final class TrendsListViewModel: HasRepositoryService {
    
    var title: String? = NSLocalizedString("GitHub Trends", comment: "")
    
    var repositories: [RepositoryViewModel] {
        didSet {
            modelUpdated?(self)
        }
    }
    
    var modelUpdated:((_ model: TrendsListViewModel)->())?
    
    init(repositories: [RepositoryViewModel]) {

        self.repositories = repositories
    }
    
    func refreshData() {
        
        SVProgressHUD.show()
        repositoryService?.retrieveGitHubDailyTrendingRepositories(completion: { [weak self] (repositories) in

            let repositories = repositories.sorted(by: { return $0.rank < $1.rank }).map { repository in
                return RepositoryViewModel(repository :repository)
            }
            
            self?.repositories = repositories
            
            SVProgressHUD.dismiss()
        })
    }
}
