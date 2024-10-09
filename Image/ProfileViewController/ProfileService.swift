//
//  ProfileService.swift
//  Image
//
//  Created by Алиса  Грищенкова on 04.10.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let username: String
    let name: String
    let bio: String?
    var loginName: String {
        return "@\(username)"
    }
    
    init(username: String, firstName: String, lastName: String?, bio: String?) {
        self.username = username
        self.name = "\(firstName) \(lastName ?? "")"
        self.bio = bio
    }
}

import Foundation

final class ProfileService {
    
    private var task: URLSessionTask?
    static let shared = ProfileService()
    private let urlSession = URLSession.shared

    private(set) var profile: Profile?
    
    
    private init() {}
    
    func makeProfileInfoURLRequest() throws -> URLRequest? {
        guard let baseURL = Constants.defaultBaseURL else {
            throw ProfileServiceErrors.invalidBaseURL
        }
        guard let url = URL(string: "/me", relativeTo: baseURL) else {
            throw ProfileServiceErrors.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuth2TokenStorage().token else {
            throw ProfileServiceErrors.tokenError
        }
        let tokenStringField = "Bearer \(token)"
        
        request.setValue(tokenStringField, forHTTPHeaderField: "Authorization")
        return request
    }
    

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = try? makeProfileInfoURLRequest() else {
            completion(.failure(ProfileServiceErrors.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let response):
                let profile = Profile(username: response.username, firstName: response.firstName, lastName: response.lastName, bio: response.bio)
                self.profile = profile
                ProfileImageService.shared.fetchProfileImageURL(username: response.username) { _ in }
                completion(.success(profile))
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(ProfileServiceErrors.fetchProfileError) - Ошибка получения данных профиля 2, \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

