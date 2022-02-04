//
//  File.swift
//  
//
//  Created by Tatiana Dmitrieva on 04.02.2022.
//

import Fluent
import Vapor

struct UserController {
    func create(req: Request) throws -> EventLoopFuture<User> {
        let reciveData = try req.content.decode(User.Create.self)
        let user = try User(name: reciveData.name,
                            email: reciveData.email,
                            passwordHash: Bcrypt.hash(reciveData.password))
        return user.save(on: req.db).transform(to: user)
    }
}

extension User {
    struct Create: Content {
        var name: String
        var email: String
        var password: String
    }
}
