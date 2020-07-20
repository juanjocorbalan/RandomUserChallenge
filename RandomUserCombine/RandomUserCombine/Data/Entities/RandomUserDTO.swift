//
//  RandomUserDTO.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation

struct RandomUserDTO: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let gender: String
    let ipAddress: String
    let avatar: String
    let city: String
    let background: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case gender = "gender"
        case ipAddress = "ip_address"
        case avatar = "avatar"
        case city = "city"
        case background = "background"
        case description = "description"
    }
}

extension RandomUserDTO: DomainConvertibleEntity {
    
    func toDomain() -> RandomUser {
        return RandomUser(id: id,
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          gender: gender,
                          ipAddress: ipAddress,
                          avatar: avatar,
                          city: city,
                          background: background,
                          description: description)
    }
}
