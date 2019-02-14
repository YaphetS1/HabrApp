//
//  UserEntity+CoreDataClass.swift
//  
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject {

	@NSManaged public var email: String
	
}
