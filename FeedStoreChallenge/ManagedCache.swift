//
//  ManagedCache.swift
//  FeedStoreChallenge
//
//  Created by Navi on 02/06/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
	static func fetch(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first
	}
}
