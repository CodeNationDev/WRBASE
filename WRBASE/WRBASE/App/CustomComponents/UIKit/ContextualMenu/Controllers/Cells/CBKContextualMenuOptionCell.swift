//
//  CBKContextualMenuOptionCell.swift
//  Commons_APPCBK
//
//  Created by Alexandre Martinez on 31/7/17.
//  Copyright © 2017 opentrends. All rights reserved.
//

import UIKit

class CBKContextualMenuOptionCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Class Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        iconLabel.tintColor = UIColor(named: "GenericWhite")!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
