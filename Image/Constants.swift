//
//  Constants.swift
//  Image
//
//  Created by Алиса  Грищенкова on 30.08.2024.
//

import Foundation

enum Constants {
    static let accessKey = "sJE5kFr82-AxCIZQ-O2u_i9JnoTuidNtNzB2VUuwJIw"
    static let secretKey = "qF9dw3TmGHXUpFtq2q4Di-2IOYt4vBlITxi1qNdRumM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    
    
}

enum ProfileServiceErrors: Error {
    case invalidBaseURL
    case invalidURL
    case tokenError
    case invalidRequest
    case fetchProfileError
}

enum ProfileImageServiceErrors: Error {
    case invalidBaseURL
    case invalidURL
    case tokenError
    case invalidRequest
    case fetchProfileError
}

