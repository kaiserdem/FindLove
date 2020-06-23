//
//  RequestType.swift
//  Find Love
//
//  Created by Kaiserdem on 19.06.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation

enum RequestType {
    
    case users
    case posts
    case groups
    case messages
    case userMessages
    case userRequest
}

extension RequestType: EndPointType {
    
    var endPoint: String {
        switch self {
        case .users:
            return "register"
        case .posts:
            return "register"
        case .groups:
            return "verify"
        case .messages:
            return "profile"
        case .userMessages:
            return "profileImage"
        case .userRequest:
            return "profileImage"
        }
    }
}
