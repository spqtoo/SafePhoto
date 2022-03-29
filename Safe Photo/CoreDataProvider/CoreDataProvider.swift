//
//  CoreDataProvider.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import Foundation
import CoreData

protocol ManagedObjectIdentifiable {

    // MARK: - Properties

    static var entityName: String { get }
}

protocol CoreDataProviderProtocol {

    // MARK: - Functions

    func performTask(_ task: @escaping (NSManagedObjectContext?) -> Void, saveCallback: ((NSManagedObjectContext?) -> Void)?)
    func get(entity: ManagedObjectIdentifiable.Type,
             predicate: NSPredicate?,
             completion: @escaping (([NSManagedObject]?) -> Void))
}

extension CoreDataProviderProtocol {

    // MARK: - Functions

    func get(entity: ManagedObjectIdentifiable.Type,
             predicate: NSPredicate? = nil,
             completion: @escaping (([NSManagedObject]?) -> Void)) {

        get(entity: entity, predicate: predicate, completion: completion)
    }

    func performTask(_ task: @escaping (NSManagedObjectContext?) -> Void) {
        performTask(task, saveCallback: nil)
    }
}

final class CoreDataProvider {

    // MARK: - Properties

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.modelName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            print(error)
//            guard let error = error else { return }
//            return
        })

        return container
    }()

    private let coreDataQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.name = "safephoto.bundle.id.coreDataQueue"
        operationQueue.qualityOfService = .userInteractive
        return operationQueue
    }()

    private var context: NSManagedObjectContext?

    // MARK: - Initialization

    required init() {
        coreDataQueue.addOperation {
            self.context = self.persistentContainer.newBackgroundContext()
        }
    }
}

extension CoreDataProvider: CoreDataProviderProtocol {

    // MARK: - Functions

    func performTask(_ task: @escaping (NSManagedObjectContext?) -> Void, saveCallback: ((NSManagedObjectContext?) -> Void)? = nil) {
        coreDataQueue.addOperation { [weak self] in
            self?.context?.perform { [weak self] in
                task(self?.context)
                self?.saveContext()
                saveCallback?(self?.context)
            }
        }
    }

    func get(entity: ManagedObjectIdentifiable.Type,
             predicate: NSPredicate?,
             completion: @escaping (([NSManagedObject]?) -> Void)) {
        performTask { [weak self] (context) in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity.entityName)
            do {
                let models = try context?.fetch(fetchRequest)
                completion(models)
                self?.saveContext()

            } catch {
                completion([])
            }
        }
    }

    // MARK: - Private functions

    private func saveContext() {
        coreDataQueue.addOperation { [weak self] in
            self?.context?.perform { [weak self] in
                do {
                    try self?.context?.save()

                } catch {
                    self?.context?.rollback()
                }
            }
        }
    }
}

extension CoreDataProvider {

    // MARK: - Types

    private enum Constants {
        static let modelName = "Model"
    }
}
