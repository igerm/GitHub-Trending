//
//  TrendTableViewCell.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit

class TrendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var starCountLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(with repository: RepositoryViewModel) {
        
        titleLabel?.text = repository.name
        starCountLabel?.text = repository.starsCount
        descriptionLabel?.text = repository.projectDescription
    }
}
