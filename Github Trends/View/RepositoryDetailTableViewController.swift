//
//  RepositoryDetailTableViewController.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-22.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit
import AlamofireImage

class RepositoryDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    var viewModel: RepositoryViewModel?  {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
    }
    
    private func reloadData() {
        
        title = viewModel?.name
        
        if let authorProfileImageURL = viewModel?.authorProfileImageURL {
            
            profileImageView?.af_setImage(withURL: authorProfileImageURL)
        }
        else {
            profileImageView?.image = nil
        }
        
        usernameLabel?.text = viewModel?.authorUsername
        descriptionLabel?.text = viewModel?.projectDescription
    }
}
