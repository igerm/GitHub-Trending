//
//  TrendsTableViewController.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit

class TrendsTableViewController: UITableViewController, HasRepositoryService {
    
    private var viewModel: TrendsListViewModel = TrendsListViewModel()  {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        refreshData()
    }
    
    private func refreshData() {
    
        repositoryService?.retrieveGitHubDailyTrendingRepositories(completion: { [weak self] (repositories) in
            
            let repositories = repositories.map { repository in
                return RepositoryViewModel(repository :repository)
            }
            
            self?.viewModel = TrendsListViewModel(repositories: repositories)
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrendTableViewCell", for: indexPath) as? TrendTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.repositories[indexPath.row])

        return cell
    }
}
