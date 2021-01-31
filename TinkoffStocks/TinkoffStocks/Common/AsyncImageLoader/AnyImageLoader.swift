//
//  AnyImageLoader.swift
//  TinkoffStocks
//
//  Created by dzhamall on 31.01.2021.
//

import UIKit

final class AnyImageLoader: ImageLoader {

    private var loadedImages: [UUID: UIImage] = [:]
    private var runningRequest: [UUID: URLSessionDataTask] = [:]
    private var previousTaskID: UUID?
    private let session: URLSession

    var placeholder: UIImage? = nil

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 1
        session = URLSession(configuration: configuration)
    }

    func load(
        imageId id: UUID,
        url: URL?,
        progress: ImageLoader.ProgressBlock?,
        completion: @escaping ImageLoader.CompletionBlock
    ) {
        guard let url = url else { return }
        if let image = loadedImages[id] {
            completion(.success(image))
            return
        }
        if let previousID = previousTaskID {
            cancelLoad(for: previousID)
            previousTaskID = nil
        }
        let task = session.dataTask(with: url) { [weak self, id] data, response, error in
            self?.urlSessionDataTaskHandler(with: id,
                                            data: data,
                                            response: response,
                                            error: error,
                                            progress: progress,
                                            completion: completion)
        }
        task.resume()
        runningRequest[id] = task
        previousTaskID = id
    }

    func cancelLoad(for imageID: UUID) {
        runningRequest[imageID]?.cancel()
        runningRequest.removeValue(forKey: imageID)
    }

    // MARK: - Private functions

    private func urlSessionDataTaskHandler(
        with id: UUID,
        data: Data?,
        response: URLResponse?,
        error: Error?,
        progress: ImageLoader.ProgressBlock?,
        completion: @escaping ImageLoader.CompletionBlock
    ) {
        defer {
            runningRequest.removeValue(forKey: id)
            previousTaskID = nil
        }
        if let error = error {
            completion(.failure(error))
            return
        }
        if response == nil {
            completion(.failure(NSError(domain: "Пустой ответ", code: 0, userInfo: nil)))
        }
        guard let imageData = data, let image = UIImage(data: imageData) else { return }
        loadedImages[id] = image
        completion(.success(image))
    }
}
