//
//  ManagedFeedImage.swift
//  FeedStoreChallenge
//
//  Created by Navi on 02/06/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
	@NSManaged var id: UUID
	@NSManaged var imageDescription: String?
	@NSManaged var location: String?
	@NSManaged var url: URL
	@NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
	var local: LocalFeedImage {
		LocalFeedImage(id: id,
		               description: imageDescription,
		               location: location,
		               url: url)
	}
}
