//
//  CDRandomUser.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import CoreData

extension CDRandomUser: ManagedToDomainConvertibleEntity {
    func update(with object: RandomUser) {
        firstName = object.firstName
        lastName = object.lastName
        email = object.email
        gender = object.gender
        ipAddress = object.ipAddress
        avatar = object.avatar
        city = object.city
        background = object.background
        story = object.description
    }
    
    func toDomain() -> RandomUser {
        return RandomUser(id: id ?? "",
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

extension RandomUser: DomainToManagedConvertibleEntity {
    
    func toManaged(in context: NSManagedObjectContext) -> CDRandomUser {
        let user = CDRandomUser(context: context)
        user.id = id
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
