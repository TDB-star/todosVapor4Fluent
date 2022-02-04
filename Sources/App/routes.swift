import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    //try app.register(collection: TodoController())
    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    app.post("todos", use: todoController.create)
    app.delete("todos", ":todosID" , use: todoController.delete)
    
    let userController = UserController()
    app.post("users", use: userController.create)
    
}
