//
//  TrendTableViewCell.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import UIKit

final class TrendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var starCountLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?

    var repository: Repository? {
        didSet {
            configureSubviews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryType = .disclosureIndicator
    }
}

private extension TrendTableViewCell {

    func configureSubviews() {
        titleLabel?.text = repository?.name
        starCountLabel?.text = "\(repository?.starsCount ?? 0) \(NSLocalizedString("Stars", comment: ""))"
        descriptionLabel?.text = repository?.projectDescription
    }
}
