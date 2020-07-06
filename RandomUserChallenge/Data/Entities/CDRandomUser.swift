//
//  CDRandomUser.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import CoreData

extension CDRandomUser: DomainConvertibleEntity {
    
    func toDomain() -> RandomUser {
        return RandomUser(identifier: identifier ?? "",
                          firstName: firstName ?? "",
                          lastName: lastName ?? "",
                          email: email ?? "",
                          gender: gender ?? "",
                          ipAddress: ipAddress ?? "",
                          avatar: avatar ?? "",
                          city: city ?? "",
                          background: background ?? "",
                          description: story ?? "")
    }
}

extension RandomUser: ManagedConvertibleEntity {
    
    func toManaged() -> CDRandomUser {
        let user = CDRandomUser(context: CoreDataStack.shared.context)
        user.identifier = identifier
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.gender = gender
        user.ipAddress = ipAddress
        user.avatar = avatar
        user.city = city
        user.background = background
        user.story = description
        return user
    }
}
