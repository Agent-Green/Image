//
//  OAuth2Service.swift
//  Image
//
//  Created by Алиса  Грищенкова on 10.09.2024.
//

import Foundation
import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let storage = OAuth2TokenStorage()
    
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
            print("Incorrect URL")
            fatalError("Incorrect URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Invalid request")
            fatalError("Invalid request")
        }
        URLSession.shared.data(for: request) {[weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    
                    guard let self else { return }
                    self.storage.token = response.accessToken
                    
                    completion(.success(response.accessToken))
                } catch {
                    print("Error decoding OAuth token response: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error fetching OAuth token: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
