//
//  HubViewModel.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import Foundation

struct HubViewModel {
	
	var title: String
	var date: String
	var text: String
	
	init(entity: HubEntity) {
		self.title = entity.title
		self.date = entity.date.stringForHubCell() ?? ""
		self.text = entity.text
	}
	
}
