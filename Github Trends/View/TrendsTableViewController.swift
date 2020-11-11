//
//  TrendsTableViewController.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import SVProgressHUD

final class TrendsTableViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)

    private var repositories: [Repository] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Trick to remove navigation bar bottom separator
        navigationController?.navigationBar.shadowImage = UIImage()
        
        title = NSLocalizedString("GitHub Trends", comment: "")
        
        tableView.tableFooterView = UIView()

        refreshData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrendTableViewCell", for: indexPath) as? TrendTableViewCell else {
            return UITableViewCell()
        }
        cell.repository = repositories[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        guard let repositoryDetailTableViewController = segue.destination as? RepositoryDetailTableViewController, let cell = sender as? TrendTableViewCell, let index = tableView.indexPath(for: cell)?.row else { return }
//
//        repositoryDetailTableViewController.viewModel = viewModel.repositories[index]
    }
}

private extension TrendsTableViewController {

    func refreshData() {
//        SVProgressHUD.show()
//        repositoryService?.retrieveGitHubDailyTrendingRepositories(completion: { [weak self] (repositories) in
//
//            let repositories = repositories.sorted(by: { return $0.rank < $1.rank }).map { repository in
//                return RepositoryViewModel(repository :repository)
//            }
//
//            self?.localRepositories = repositories
//            self?.repositories = repositories
//
//            SVProgressHUD.dismiss()
//        })
    }
}

extension TrendsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.filterContent(with: searchBar.text)
    }
}
