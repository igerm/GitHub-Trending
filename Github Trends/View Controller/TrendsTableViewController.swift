//
//  TrendsTableViewController.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import RealmSwift

final class TrendsTableViewController: UITableViewController {

    private var repositories: DataAccessResults<Repository>?
    private var repositoriesObserver: NotificationToken?
    private var dataAccessService: DataAccessServiceProtocol?

    init(dataAccessService: DataAccessServiceProtocol?) {
        self.dataAccessService = dataAccessService
        super.init(style: .plain)

        title = NSLocalizedString("GitHub Trends", comment: "")
        tableView.tableFooterView = UIView()

        repositoriesObserver = repositories?.observe { [weak self] _ in
            self?.tableView.reloadData()
        }
        refreshData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrendTableViewCell", for: indexPath) as? TrendTableViewCell else {
            return UITableViewCell()
        }
        cell.repository = repositories?[indexPath.row]
        return cell
    }
}

private extension TrendsTableViewController {

    func refreshData() {
        dataAccessService?.getObjects(request: RepositoryDataAccessor.getAll) { [weak self] (response: Response<DataAccessResults<Repository>, DataAccessError>) in
            switch response {
            case .success(let repositories):
                self?.repositories = repositories
            case .failure:
                break
            }
        }
    }
}
