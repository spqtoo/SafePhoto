//
//  AlbumsModel.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import Foundation
import CoreData
import UIKit

protocol AlbumsModelProtocol {

    var delegate: AlbumsModelDelegate? { get set }
    var items: [Album] { get }

    func reloadData()
    func select(album: Album)
    func deleteSelected()
    func deselectAll()
    func isAlbumSelected(_ album: Album) -> Bool
    func entity(for album: Album) -> AlbumEntity?
}

protocol AlbumsModelDelegate: AnyObject {

    func dataDidChange()
    func updateCells()
}

final class AlbumsModel {

    private lazy var coreDataProvider = diContainer.resolve(CoreDataProviderProtocol.self)!
    private var selectedItems: [String] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.updateCells()
            }
        }
    }
    private(set) var items: [Album] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.dataDidChange()
            }
        }
    }
    private var entities: [AlbumEntity] = []
    weak var delegate: AlbumsModelDelegate?
}

extension AlbumsModel: AlbumsModelProtocol {

    func reloadData() {
        coreDataProvider.get(entity: AlbumEntity.self, predicate: nil) { [weak self] objects in
            DispatchQueue.global().async { [weak self] in
                let items = objects?.converted() ?? []
                self?.entities = items
                Album.create(items) { [weak self] dto in
                    self?.items = dto.compactMap { $0 }
                }
            }
        }
    }

    func select(album: Album) {
        switch selectedItems.contains(album.albumName) {
        case true:
            selectedItems.removeAll(where: { $0 == album.albumName })

        case false:
            selectedItems.append(album.albumName)
        }
    }

    func deleteSelected() {
        let selected = selectedItems
        print("hehe", selected)
        coreDataProvider.performTask { context in
            guard let context = context else { return }
            let items: [AlbumEntity] = selected.compactMap {
                let fetchRequest = NSFetchRequest<AlbumEntity>(entityName: AlbumEntity.entityName)
                fetchRequest.predicate = .init(format: "nameOfAlbum == %@", $0)
                return try? context.fetch(fetchRequest).first
            }
            items.forEach { context.delete($0) }
        } saveCallback: { [weak self] _ in
            self?.reloadData()
        }
    }

    func deselectAll() {
        selectedItems.removeAll()
    }

    func isAlbumSelected(_ album: Album) -> Bool {
        return selectedItems.contains(album.albumName)
    }

    func entity(for album: Album) -> AlbumEntity? {
        entities.first(where: { $0.nameOfAlbum == album.albumName })
    }
}

extension AlbumsModel: DISupportable {}

private extension Array where Element == NSManagedObject {

    func converted() -> [AlbumEntity] {
        compactMap { $0 as? AlbumEntity }
    }
}
