//
//  AlbumViewerModel.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import Foundation
import CoreData
import UIKit

protocol AlbumViewerModelProtocol {

    var album: AlbumEntity { get }
    var delegate: AlbumViewerModelDelegate? { get set }
    var images: [AlbumViewerModel.ImageModel] { get }
    var albumDto: Album? { get }
    var countOfImages: Int { get }

    func reloadData()
    func add(_ images: [UIImage])
    func changeAlbum(image: UIImage)
    func changeAlbum(title: String)
    func deleteAlbum(completion: @escaping () -> Void)
    func titleChanged(_ value: String)
//    func select(album: Album)
//    func deleteSelected()
//    func deselectAll()
//    func isAlbumSelected(_ album: Album) -> Bool
//    func entity(for album: Album) -> AlbumEntity?
}

protocol AlbumViewerModelDelegate: AnyObject {

    func dataDidChange()
    func albumDidChange()
}

final class AlbumViewerModel {

    private lazy var coreDataProvider = diContainer.resolve(CoreDataProviderProtocol.self)!
    private var selectedItems: [String] = []
    private var items: [ImageEntity] = [] {
        didSet {
            images = items.compactMap {
                if let data = $0.lowSize, let image = UIImage(data: data) { return .init(objectId: $0.objectID, image: image) }
                return nil
            }
        }
    }
    private(set) var images: [ImageModel] = [] {
        didSet {
            callDelegate()
        }
    }
    let album: AlbumEntity
    private(set) var albumDto: Album?

    weak var delegate: AlbumViewerModelDelegate?

    required init(album: AlbumEntity) {
        self.album = album
        Album.create(album) { [weak self] dto in
            self?.albumDto = dto
        }
    }
}

extension AlbumViewerModel: AlbumViewerModelProtocol {

    var countOfImages: Int { album.images?.count ?? .zero }
    
    func reloadData() {
        let images = album.images?.compactMap { $0 as? ImageEntity } ?? []
        self.items = images
    }

    func titleChanged(_ value: String) {
        coreDataProvider.performTask { [weak self] _ in
            self?.album.nameOfAlbum = value
        }
    }

    func add(_ images: [UIImage]) {
        coreDataProvider.performTask { [weak self] context in
            guard let context = context else { return }

            guard let self = self else { return }

            let entities: [ImageEntity] = images.compactMap {
                let fullSize = $0.jpegData(compressionQuality: 0.5)
                let lowSize = $0.jpegData(compressionQuality: 0.1)
                let entity = ImageEntity(context: context, album: self.album, lowSize: lowSize, fullSize: fullSize)
                return entity
            }

            entities.forEach { self.album.addToImages($0) }
        } saveCallback: { [weak self] _ in
            self?.reloadData()
        }
    }

    func changeAlbum(image: UIImage) {
        coreDataProvider.performTask { [weak self] context in
            self?.album.image = image.jpegData(compressionQuality: 1)
        } saveCallback: { [weak self] _ in
            self?.callAlbumDidChangeDelegate()
        }
    }

    func changeAlbum(title: String) {
        guard title.isEmpty == false else { return }
        coreDataProvider.performTask { [weak self] context in
            self?.album.nameOfAlbum = title
        } saveCallback: { [weak self] _ in
            self?.callAlbumDidChangeDelegate()
        }
    }

    func deleteAlbum(completion: @escaping () -> Void) {
        coreDataProvider.performTask { [weak self] context in
            guard let context = context else { return }
            guard let album = self?.album else { return }

            context.delete(album)
        } saveCallback: { _ in
            DispatchQueue.main.async { completion() }
        }
    }

    private func callDelegate() {
        Album.create(album) { [weak self] dto in
            self?.albumDto = dto
            self?.delegate?.dataDidChange()
        }
    }

    private func callAlbumDidChangeDelegate() {
        Album.create(album) { [weak self] dto in
            self?.albumDto = dto
            self?.delegate?.albumDidChange()
        }
    }

//    func select(album: Album) {
//        selectedItems.append(album.albumName)
//    }

//    func deleteSelected() {
//        let selected = selectedItems
//        coreDataProvider.performTask { context in
//            guard let context = context else { return }
//            let items: [AlbumEntity] = selected.compactMap {
//                let fetchRequest = NSFetchRequest<AlbumEntity>()
//                fetchRequest.predicate = .init(format: "nameOfAlbum == %@", $0)
//                return try? context.fetch(fetchRequest).first
//            }
//            items.forEach { context.delete($0) }
//        }
//    }
//
//    func deselectAll() {
//        selectedItems.removeAll()
//    }
//
//    func isAlbumSelected(_ album: Album) -> Bool {
//        return selectedItems.contains(album.albumName)
//    }
//
//    func entity(for album: Album) -> AlbumEntity? {
//        entities.first(where: { $0.nameOfAlbum == album.albumName })
//    }

    struct ImageModel {
        let objectId: NSManagedObjectID
        let image: UIImage
    }
}

extension AlbumViewerModel: DISupportable {}

private extension Array where Element == NSManagedObject {

    func converted() -> [AlbumEntity] {
        compactMap { $0 as? AlbumEntity }
    }
}
