//
//  TrendsTableViewController.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit

final class TrendsTableViewController: UITableViewController {
    
    private var viewModel: TrendsListViewModel = TrendsListViewModel(repositories: [])  {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trick to remove navigation bar bottom separator
        navigationController?.navigationBar.shadowImage = UIImage()
        
        title = viewModel.title
        
        tableView.tableFooterView = UIView()
        
        viewModel.refreshData()
        
        viewModel.modelUpdated = { [weak self] viewModel in
            
            self?.viewModel = viewModel
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let repositoryDetailTableViewController = segue.destination as? RepositoryDetailTableViewController, let cell = sender as? TrendTableViewCell, let index = tableView.indexPath(for: cell)?.row else { return }
        
        repositoryDetailTableViewController.viewModel = viewModel.repositories[index]
    }
}
