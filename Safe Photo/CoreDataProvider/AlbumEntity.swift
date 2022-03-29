//
//  AlbumEntity.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import Foundation
import CoreData
import UIKit

@objc(AlbumEntity)
public class AlbumEntity: NSManagedObject {

    convenience init?(context: NSManagedObjectContext, nameOfAlbum: String, image: Data?) {
        self.init(context: context)
        self.nameOfAlbum = nameOfAlbum
        self.image = image
        self.lastUpdate = .init()
    }
}

extension AlbumEntity: ManagedObjectIdentifiable {
    static var entityName: String { "AlbumEntity" }
}

extension AlbumEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumEntity> {
        return NSFetchRequest<AlbumEntity>(entityName: Self.entityName)
    }

    @NSManaged public var nameOfAlbum: String?
    @NSManaged public var image: Data?
    @NSManaged public var images: NSSet?
    @NSManaged public var lastUpdate: Date?

}

// MARK: Generated accessors for images
extension AlbumEntity {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageEntity)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageEntity)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

struct Album {
    let albumName: String
    var image: UIImage?

    static func create(_ entity: AlbumEntity, completion: @escaping (Album?) -> Void) {
        DispatchQueue.global().async {
            let album = Album(entity)
            DispatchQueue.main.async { completion(album) }
        }
    }

    static func create(_ entities: [AlbumEntity], completion: @escaping ([Album?]) -> Void) {
        DispatchQueue.global().async {
            let albums = entities.compactMap { Album($0) }
            DispatchQueue.main.async { completion(albums) }
        }
    }

    private static func downsample(data: Data, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions)!
//        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!

        let maxDimentionInPixels = max(pointSize.width, pointSize.height) * scale

        let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                          kCGImageSourceShouldCacheImmediately: true,
                                    kCGImageSourceCreateThumbnailWithTransform: true,
                                           kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels] as CFDictionary
        let downsampledImage =     CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)!

        return UIImage(cgImage: downsampledImage)
    }

    private init?(_ entity: AlbumEntity) {
        guard let name = entity.nameOfAlbum else { return nil }
        if let imageData = entity.image {
//           let image = Self.downsample(data: imageData, to: .init(width: UIScreen.width, height: UIScreen.height / 2)) {
            self.image = Self.downsample(data: imageData, to: .init(width: UIScreen.width, height: UIScreen.height / 2))
        }
        self.albumName = name
    }
}
