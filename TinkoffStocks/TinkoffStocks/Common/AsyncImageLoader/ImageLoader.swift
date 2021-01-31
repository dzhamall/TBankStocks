//
//  ImageLoader.swift
//  TinkoffStocks
//
//  Created by dzhamall on 31.01.2021.
//

import UIKit

protocol ImageLoader {
    typealias ProgressBlock = (_ receivedSize: Int, _ totalSize: Int) -> Void
    typealias CompletionBlock = (Result<UIImage, Error>) -> Void

    var placeholder: UIImage? { get }

    func load(imageId id: UUID,
              url: URL?,
              progress: ImageLoader.ProgressBlock?,
              completion: @escaping ImageLoader.CompletionBlock)

    func cancelLoad(for imageID: UUID)
}
