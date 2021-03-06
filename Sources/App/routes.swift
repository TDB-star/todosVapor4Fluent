import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let userController = UserController()
    
    let basicGroup = app.grouped(User.guardMiddleware())
    basicGroup.post("login", use: userController.login)
    
    let tokenGroup = app.grouped(UserToken.guardMiddleware())

    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    tokenGroup.post("todos", use: todoController.create)
    tokenGroup.delete("todos", ":todosID" , use: todoController.delete)
    
    app.post("users", use: userController.create)
}


