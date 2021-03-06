//
//  File.swift
//  
//
//  Created by Tatiana Dmitrieva on 04.02.2022.
//

import Foundation
import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema: String = "user_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "value")
    var value: String
    
    @Parent(key: "user_id")
    var user: User
    
    init() {}
    
    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
    
}
