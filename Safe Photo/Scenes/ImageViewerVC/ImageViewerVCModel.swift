//
//  ImageViewerVCModel.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 30.11.2021.
//

import Foundation
import UIKit

protocol ImageViewerVCModelProtocol {
    var pictures: [ImageViewerVCModel.ImageModel] { get }
    var delegate: ImageViewerModelDelegate? { get set }
}

protocol ImageViewerModelDelegate: AnyObject {
    func dataDidChange()
}


// 2 bag
final class ImageViewerVCModel {

    private let album: AlbumEntity
    private(set) var pictures: [ImageModel] = [] {
        didSet {
            callDelegate()
        }
    }
    
    weak var delegate: ImageViewerModelDelegate?
//    {
//        guard let set = album.images?.allObjects else { return [] }
//        let images = set.compactMap { $0 as? ImageEntity }
//        return images.compactMap { .init($0.fullSize) }
//    }


    required init(_ album: AlbumEntity) {
        self.album = album
        print("AYE PICTURES", pictures)
        guard let set = album.images?.allObjects else { print("else guard 1st line"); return }
        print(set.count)
        let images = set.compactMap { $0 as? ImageEntity }
        print(images.count)
        ImageModel.create(images) { [weak self] models in
            self?.pictures = models.compactMap { $0 }
            print("models SUUUUUKAAAA : \(self?.pictures.count)")

        }
        print("PICTURES EEEEE: \(self.pictures.count)")
        
    }
}

extension ImageViewerVCModel: ImageViewerVCModelProtocol {

    private func callDelegate() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.dataDidChange()
        }
//        guard let set = album.images?.allObjects else { print("else guard 1st line"); return }
//        let images = set.compactMap { $0 as? ImageEntity }
//        ImageModel.create(images) { [weak self] models in
//            self?.pictures = models.compactMap { $0 }
////            self?.delegate?.dataDidChange()

//        }
    }
}

extension ImageViewerVCModel {
    struct ImageModel {
        let image: UIImage

        init?(_ data: Data?) {
            guard let data = data else { return nil }
            guard let image = UIImage(data: data) else { print("ImageModel ELSE 2 : \(data)"); return nil }
//            print("ImageModel BEFORE SELF.IMAGE : \(image)")
            self.image = image
//            print("ImageModel AFTER SELF.IMAGE : \(self.image)")
        }

        static func create(_ entities: [ImageEntity], completion: @escaping ([ImageViewerVCModel.ImageModel?]) -> Void) {
            DispatchQueue.global().async {
                let albums = entities.compactMap { ImageViewerVCModel.ImageModel($0.fullSize) }
                DispatchQueue.main.async { completion(albums) }
            }
        }
    }
}
