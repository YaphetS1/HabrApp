//
//  HubTableViewCell.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved. on 14/02/2019.
//

import UIKit

final class HubTableViewCell: UITableViewCell {

	@IBOutlet weak var hubTitleLabel: UILabel!
    @IBOutlet weak var hubDateLabel: UILabel!
	@IBOutlet weak var hubTextLabel: UILabel!
	
	func configure(with viewModel: HubViewModel) {
		hubTitleLabel.text = viewModel.title
		hubDateLabel.text = viewModel.date
		hubTextLabel.text = viewModel.text
	}
	
}
