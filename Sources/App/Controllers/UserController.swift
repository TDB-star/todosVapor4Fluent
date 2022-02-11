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
    
    func login(req: Request) throws -> EventLoopFuture<UserToken> {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db).transform(to: token)
    }
}

extension User {
    struct Create: Content {
        var name: String
        var email: String
        var password: String
    }
}

extension User: Authenticatable {
    
    static var usernameKey: KeyPath<User, Field<String>> = \User.$email
    static var passwordHashKey: KeyPath<User, Field<String>> = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
       return try Bcrypt.verify(password, created: self.passwordHash)
    }
    
    func generateToken() throws -> UserToken {
        return try UserToken(value: [UInt8].random(count: 16).base64,
                         userID: self.requireID())
    }
}

extension UserToken: ModelTokenAuthenticatable {
    
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user
    
    var isValid: Bool {
        return true
    }
}
