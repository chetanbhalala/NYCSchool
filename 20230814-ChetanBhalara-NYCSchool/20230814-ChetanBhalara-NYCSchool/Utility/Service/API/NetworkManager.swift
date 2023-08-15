//
//  NetworkManager.swift
//  20230814-ChetanBhalara-NYCSchool
//
//  Created by Chetan Bhalara on 8/15/23.
//

import Foundation
import Combine

enum Endpoint: String {
    case get = ""
    case place = " "
}

enum HttpMethods: String {
    case GET
    case POST
}

/// We can do more managebale this class to saperate Endpoint & Error mechenisam.
/// Also we can improve this class for OAuth 2.0

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    private var cancellables = Set<AnyCancellable>()
    //private let baseURL = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    
    
    /// generic method which is accept
    /// Endpoint
    /// HTTP Method
    /// Model Type which is generic
    func makeNetworkCall<T: Decodable>(endpoint: Endpoint,httpMethod:HttpMethods, type: T.Type, baseURL: String) async -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self1 = self, let url = URL(string: baseURL) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            let request = URLRequest(url: url)
            
            //            debugPrint("URL is \(String(describing: request.urlRequest?.url?.absoluteString))")
            URLSession.shared.dataTaskPublisher(for: (request))
                .tryMap { (data, response) -> Data in
                    
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        print(error)
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { value in
                    //debugPrint("Response : =============\(value)=============")
                    promise(.success(value))
                })
                .store(in: &self1.cancellables)
        }
    }
}


enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
