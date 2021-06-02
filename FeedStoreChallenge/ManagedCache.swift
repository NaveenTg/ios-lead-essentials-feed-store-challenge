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
	var localFeed: [LocalFeedImage] {
		return feed
			.compactMap { $0 as? ManagedFeedImage }
			.map { $0.local }
	}

	static func feed(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
		return NSOrderedSet(array: localFeed.map { feed in
			let managed = ManagedFeedImage(context: context)
			managed.id = feed.id
			managed.imageDescription = feed.description
			managed.location = feed.location
			managed.url = feed.url
			return managed
		})
	}
}

extension ManagedCache {
	static func fetch(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first
	}

	static func newInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
		try fetch(in: context).map(context.delete)
		return ManagedCache(context: context)
	}
}
