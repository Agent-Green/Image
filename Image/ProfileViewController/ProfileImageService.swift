//
//  ProfileImageService.swift
//  Image
//
//  Created by Алиса  Грищенкова on 04.10.2024.
//

import Foundation

struct ProfileImage: Codable {
    let small: String
    let large: String
}

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}


final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var profileImageURL: String?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private init() {}
    
    func makeProfileImageRequest(username: String) throws -> URLRequest? {
        guard let baseURL = Constants.defaultBaseURL else {
            throw ProfileImageServiceErrors.invalidBaseURL
        }
        guard let url = URL(string: "/users/\(username)", relativeTo: baseURL) else {
            throw ProfileImageServiceErrors.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuth2TokenStorage().token else {
            throw ProfileImageServiceErrors.tokenError
        }
        let tokenStringField = "Bearer \(token)"
        
        request.setValue(tokenStringField, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = try? makeProfileImageRequest(username: username) else {
            completion(.failure(ProfileImageServiceErrors.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let response):
                let profileImage = response.profileImage.large
                self.profileImageURL = profileImage
                completion(.success(profileImage))
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": profileImage])
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(ProfileImageServiceErrors.fetchProfileError) - Ошибка получения URL изображения профиля, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
