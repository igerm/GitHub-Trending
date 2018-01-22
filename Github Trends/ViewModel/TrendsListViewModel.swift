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
    
    private var localRepositories: [RepositoryViewModel]?
    
    var filteredRepositories: [RepositoryViewModel]? {
        didSet {
            guard let filteredRepositories = filteredRepositories else { return }
            repositories = filteredRepositories
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
            
            self?.localRepositories = repositories
            self?.repositories = repositories
            
            SVProgressHUD.dismiss()
        })
    }
    
    func filterContent(with searchText: String?) {
        
        guard let searchText = searchText else { return }
        
        if searchText.isEmpty, let localRepositories = localRepositories {
            repositories = localRepositories
        }
        else {
         
            filteredRepositories = localRepositories?.filter { repository in
                return repository.name?.lowercased().contains(searchText.lowercased()) == true
            }
        }
    }
}
