import Fluent
import Vapor
import Fluent

struct TodoController {
//    func boot(routes: RoutesBuilder) throws {
//        let todos = routes.grouped("todos")
//        todos.get(use: index)
//        todos.post(use: create)
//        todos.group(":todoID") { todo in
//            todo.delete(use: delete)
//        }
//    }

    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        return Todo.query(on: req.db)
            .sort(\.$title, .ascending)
            .all()
    }
    
    func count(req: Request) throws -> EventLoopFuture<Int> {
        return Todo.query(on: req.db).all().map { todoList -> Int in
            todoList.count
        }
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let todo: Todo = try req.content.decode(Todo.self)
        return todo.save(on: req.db).transform(to: todo)
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
//: RouteCollection
