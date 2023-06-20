//
//  NetworkService.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import Foundation

enum NetworkError: Error {
    case loading(Error)
    case urlGeneration
}

protocol NetworkService {
    typealias CompletionHandler = (Result<Data, NetworkError>) -> Void
    
    func request(path: PathType, completion: @escaping CompletionHandler)
}

final class DefaultNetworkService { }

// MARK: - Private

private extension DefaultNetworkService {
    
    func request(with url: URL, completion: @escaping CompletionHandler) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async { completion(.success(data)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.loading(error))) }
            }
        }
    }
    
    func makeURL(from fileName: String) throws -> URL {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            throw NetworkError.urlGeneration
        }
        return url
    }
    
    func makeURL(with path: String) throws -> URL {
        guard let url = URL(string: path) else {
            throw NetworkError.urlGeneration
        }
        
        return url
    }
}

// MARK: - NetworkService

extension DefaultNetworkService: NetworkService {
    func request(path: PathType, completion: @escaping CompletionHandler) {
        do {
            let url: URL
            switch path {
            case let .fileName(name):
                url = try makeURL(from: name)
            case let .urlPath(path):
                url = try makeURL(with: path)
            }
            
            return request(with: url, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
        }
    }
}
