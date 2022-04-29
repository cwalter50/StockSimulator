//
//  NetworkingManager.swift
//  StockSimulator
//
//  Created by Christopher Walter on 4/27/22.
//

import Foundation
import Combine


class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "[🔥] Bad response from the URL: \(url)"
            case .unknown:
                return "[⚠️] unknown error occurred"
            }
        }
    }
    
    static func download(urlRequest: URLRequest, url: URL) -> AnyPublisher<Data, Error> {
        
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default)) // background thread
            .tryMap({ try handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main) // main thread
            .eraseToAnyPublisher() // converts the Publisher to AnyPublisher, so we have a nice return type
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
