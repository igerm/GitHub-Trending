//
//  RepositoryService.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import Alamofire
import AlamofireRSSParser
import AlamofireSwiftyJSON
import AlamofireCodable

protocol RepositoryServiceProtocol {
    
    func retrieveGitHubDailyTrendingRepositories(completion:((_ repositories: [Repository]) ->())?)
    
    func retrieveReadme(repository: Repository, completion:((_ readmeString: String?) ->())?)
}

final class RepositoryService: RepositoryServiceProtocol {

    private var dataAccessService: DataAccessServiceProtocol?

    init(dataAccessService: DataAccessServiceProtocol?) {
        self.dataAccessService = dataAccessService
    }

    func retrieveGitHubDailyTrendingRepositories(completion:((_ repositories: [Repository]) ->())?) {
        dataAccessService?.getObjects(request: RepositoryDataAccessor.getAll) { (response: Response<DataAccessResults<Repository>, DataAccessError>) in
            switch response {
            case .success(let repositories):
                completion?(Array(repositories))
            case .failure:
                completion?([])
            }
        }
    }
    
    func retrieveReadme(repository: Repository, completion:((_ readmeString: String?) ->())?) {
//        apiService.dataRequest(for: RepositoryRouter.getReadme(repository: repository)).responseSwiftyJSON { response in
//            switch response.result {
//            case .success(let result):
//
//                guard let urlString = result["download_url"].string, let url = URL(string: urlString) else {
//                    completion?(nil)
//                    return
//                }
//
//                let session = URLSession(configuration: .default)
//                let task = session.dataTask(with: url) { data, _, _ in
//                    let str = String(data: data!, encoding: String.Encoding.utf8)
//                    DispatchQueue.main.async {
//                        completion?(str)
//                    }
//                }
//                task.resume()
//
//            case .failure:
//                completion?(nil)
//            }
//        }
    }
}
