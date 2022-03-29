//
//  ImageEntity.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import Foundation
import CoreData

@objc(ImageEntity)
public class ImageEntity: NSManagedObject {

    convenience init?(context: NSManagedObjectContext, album: AlbumEntity, createDate: Date = Date(), lowSize: Data?, fullSize: Data?) {
        self.init(context: context)
        self.createDate = createDate
        self.lowSize = lowSize
        self.fullSize = fullSize
        self.album = album
    }
}

extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: Self.entityName)
    }

    @NSManaged public var lowSize: Data?
    @NSManaged public var fullSize: Data?
    @NSManaged public var createDate: Date?
    @NSManaged public var album: AlbumEntity?

}

extension ImageEntity: ManagedObjectIdentifiable {
    static var entityName: String { "ImageEntity" }
}
