//
//  OAuth2Service.swift
//  Image
//
//  Created by Алиса  Грищенкова on 10.09.2024.
//

import Foundation
import UIKit

enum AuthServiceErrors: Error {
    case invalidRequest
    case invalidResponse
    case invalidUrl
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let storage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("Incorrect URL")
            fatalError("Incorrect URL")
        }
        
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            assertionFailure("Failed to create URL")
            print("Incorrect URL")
            fatalError("Incorrect URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceErrors.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthServiceErrors.invalidRequest))
            return
        }
        
        
        let task = urlSession.objectTask(for: request) { [weak self] (result:
            Result<OAuthTokenResponseBody, Error>) in
                switch result {
                case .success(let response):
                    self?.storage.token = response.accessToken
                    completion(.success(response.accessToken))
                case .failure(let error):
                    print("[\(String(describing: self)).\(#function)]: \(AuthServiceErrors.invalidResponse) - Ошибка получения OAuth токена, \(error.localizedDescription)")
                    completion(.failure(AuthServiceErrors.invalidResponse))
                }
                self?.task = nil
                self?.lastCode = nil

        }
        self.task = task
        task.resume()
        
    }
}
