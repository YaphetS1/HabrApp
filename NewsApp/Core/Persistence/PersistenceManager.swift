//
//  PersistenceManager.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager {
	
	private init() {}
	static let shared = PersistenceManager()
	
	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	lazy var context = container.viewContext
	
	func newBackgroundContext() -> NSManagedObjectContext {
		return container.newBackgroundContext()
	}
	
	func save(_ context: NSManagedObjectContext? = nil, completion: (() -> Void)? = nil) {
		let contextToSave = context ?? self.context
		
		if contextToSave.hasChanges {
			do {
				try contextToSave.save()
				print("Saved successfully")
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
		
		completion?()
	}
	
	func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
		let entityName = String(describing: objectType)
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		
		do {
			let fetchedObjects = try context.fetch(fetchRequest) as? [T]
			return fetchedObjects ?? []
		} catch {
			print(error)
			return []
		}
	}
	
	func fetchFirst<T: NSManagedObject>(_ objectType: T.Type) -> T? {
		return fetch(objectType).first
	}
	
	func delete(_ object: NSManagedObject) {
		context.delete(object)
		save()
	}
}
