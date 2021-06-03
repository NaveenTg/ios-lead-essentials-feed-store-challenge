//
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
	private static let modelName = "FeedStore"
	private static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

	private let container: NSPersistentContainer
	private let context: NSManagedObjectContext

	struct ModelNotFound: Error {
		let modelName: String
	}

	public init(storeURL: URL) throws {
		guard let model = CoreDataFeedStore.model else {
			throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
		}

		container = try NSPersistentContainer.load(
			name: CoreDataFeedStore.modelName,
			model: model,
			url: storeURL
		)
		context = container.newBackgroundContext()
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		performContext { context in
			do {
				if let cache = try ManagedCache.fetch(in: context) {
					completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
				} else {
					completion(.empty)
				}
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		performContext { context in
			do {
				let newCache = try ManagedCache.newInstance(in: context)
				newCache.feed = ManagedCache.feed(from: feed, in: context)
				newCache.timestamp = timestamp
				try context.save()
				completion(nil)
			} catch {
				context.rollback()
				completion(error)
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		performContext { context in
			do {
				try ManagedCache.fetch(in: context).map(context.delete).map(context.save)
				completion(nil)
			} catch {
				context.rollback()
				completion(error)
			}
		}
	}

	private func performContext(_ action: @escaping (NSManagedObjectContext) -> Void) {
		context.perform { [context] in action(context) }
	}
}
