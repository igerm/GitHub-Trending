//
//  RepositoryService.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import Alamofire
import AlamofireRSSParser
import AlamofireObjectMapper
import AlamofireSwiftyJSON
import SwiftyMarkdown

protocol RepositoryServiceProtocol {
    
    func retrieveGitHubDailyTrendingRepositories(completion:((_ repositories: [Repository]) ->())?)
    
    func retrieveReadme(repository: Repository, completion:((_ readmeAttibutedString: NSAttributedString?) ->())?)
}

final class RepositoryService: RepositoryServiceProtocol, HasAPIService {

    func retrieveGitHubDailyTrendingRepositories(completion:((_ repositories: [Repository]) ->())?) {
        
        Alamofire.request(Bundle.gitHubDailyTrendingURLString).responseRSS() { [weak self] (response) -> Void in

            guard let items = response.result.value?.items else {
                completion?([])
                return
            }
            
            let group = DispatchGroup()
            
            var allRepositories: [Repository] = []
            
            items.forEach({ (item) in
                
                guard let name = item.link?.replacingOccurrences(of: "https://github.com/", with: "") else {
                    return
                }
                
                group.enter()
                self?.apiService?.dataRequest(forUrlRequestConvertible: RepositoryRouter.getRepositoryDetails(name: name)).responseObject { (response: DataResponse<Repository>) in
                    
                    print(response.request?.url ?? "")
                    
                    switch response.result {
                    case .success(let repository):
                        
                        print(repository.name ?? "nil")
                        
                        if let index = items.index(where: {
                            
                            return $0.link == item.link
                        }) {
                            
                            print("rank: \(index)\n...")
                            repository.rank = index
                        }
                        
                        allRepositories.append(repository)
                        
                    case.failure(let error):
                        
                        print(error)
                    }
                    
                    group.leave()
                }
            })
            
            group.notify(queue: .main, execute: {
                
                completion?(allRepositories)
            })
        }
    }
    
    func retrieveReadme(repository: Repository, completion:((_ readmeAttibutedString: NSAttributedString?) ->())?) {
        
        apiService?.dataRequest(forUrlRequestConvertible: RepositoryRouter.getReadme(repository: repository)).responseSwiftyJSON { (response) in
            
            switch response.result {
            case .success(let result):
                
                guard let urlString = result["download_url"].string, let url = URL(string: urlString) else {
                    completion?(nil)
                    return
                }
                
                completion?(SwiftyMarkdown(url: url)?.attributedString())
                
            case.failure(_):
                completion?(nil)
            }
        }
    }
}
