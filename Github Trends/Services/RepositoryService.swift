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

final class RepositoryService: RepositoryServiceProtocol, HasAPIService {

    func retrieveGitHubDailyTrendingRepositories(completion:((_ repositories: [Repository]) ->())?) {
        //GitHub Trending API Endpoint doesn't exist so I found an RSS feed to use
        Alamofire.request(Bundle.gitHubDailyTrendingURLString).responseRSS() { [weak self] response -> Void in
            guard let items = response.result.value?.items else {
                completion?([])
                return
            }
            
            let group = DispatchGroup()
            
            var allRepositories: [Repository] = []
            
            items.forEach { item in
                
                //I need to strip the domain to get the path of the repo
                guard let name = item.link?.replacingOccurrences(of: "https://github.com/", with: "") else {
                    return
                }
                
                group.enter()
                self?.apiService?.dataRequest(for: RepositoryRouter.getRepositoryDetails(name: name)).responseObject(completionHandler: { (response: DataResponse<Repository>) in
                    
                    switch response.result {
                    case .success(let repository):
                        
                        //We can rely on the order of the array to find the ranking also looks like the only way appart from stripping down the title
                        if let index = items.firstIndex(where: {
                            $0.link == item.link
                        }) {
                            repository.rank = index
                        }
                        
                        allRepositories.append(repository)
                        
                    case .failure:
                        break
                    }
                    
                    group.leave()
                })
            }
            
            group.notify(queue: .main, execute: {
                completion?(allRepositories)
            })
        }
    }
    
    func retrieveReadme(repository: Repository, completion:((_ readmeString: String?) ->())?) {
        apiService?.dataRequest(for: RepositoryRouter.getReadme(repository: repository)).responseSwiftyJSON { response in
            switch response.result {
            case .success(let result):
                
                guard let urlString = result["download_url"].string, let url = URL(string: urlString) else {
                    completion?(nil)
                    return
                }
                
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { data, _, _ in
                    let str = String(data: data!, encoding: String.Encoding.utf8)
                    DispatchQueue.main.async {
                        completion?(str)
                    }
                }
                task.resume()
                
            case .failure:
                completion?(nil)
            }
        }
    }
}
