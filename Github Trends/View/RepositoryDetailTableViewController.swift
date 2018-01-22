//
//  RepositoryDetailTableViewController.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-22.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit
import AlamofireImage
import MarkdownView
import SVProgressHUD

final class RepositoryDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var markdownView: MarkdownView? {
        didSet {
            markdownView?.isScrollEnabled = false
            markdownView?.onRendered = { [weak self] height in
                
                self?.markdownViewHeightConstraint?.constant = height + 50
                self?.tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var markdownViewHeightConstraint: NSLayoutConstraint?
    
    var viewModel: RepositoryViewModel?  {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        
        viewModel?.modelUpdated = { [weak self] viewModel in
            
            self?.viewModel = viewModel
        }
        
        viewModel?.refreshData()
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

        markdownView?.load(markdown: viewModel?.readmeString)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }
}
