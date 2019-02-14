//
//  HubEntity+CoreDataClass.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//
//

import Foundation
import CoreData
import SWXMLHash

@objc(HubEntity)
public class HubEntity: NSManagedObject {

	@NSManaged public var title: String
	@NSManaged public var link: String
	@NSManaged public var date: Date
	@NSManaged public var text: String
	
}

// MARK: - XML
extension HubEntity {
	
	private enum Keys {
		static let title = "title"
		static let link = "link"
		static let date = "pubDate"
		static let text = "description"
	}
	
	func populateFromXML(_ xml: XMLIndexer) {
		self.title = xml[Keys.title].element?.text ?? ""
		self.link = xml[Keys.link].element?.text ?? ""
		self.date = xml[Keys.date].element?.text.dateFromHabrRss() ?? Date()
		self.text = xml[Keys.text].element?.text.removeHtmlTags().trim() ?? ""
	}

}
