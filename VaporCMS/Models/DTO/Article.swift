import MySQL
import Vapor

protocol Renderable{
    func context() -> [String: Node]
}

extension Renderable{
    func context() -> [String: Node]{

        var dic = [String: Node]()
        let mirror = Mirror(reflecting: self)

        for child in mirror.children where child.label != nil{
            dic.updateValue(Node(String(describing: child.value)), forKey: child.label!)
        }

        return dic
    }
}

struct Article: QueryRowResultType, Renderable{
    var id: Int
    var title: String
    var content: String
    var isPublished: Bool
    var createdAt: String
    
    static func decodeRow(r: QueryRowResult) throws -> Article {
        return try Article(
            id: r <| "id",
            title: r <| "title",
            content: r <| "content",
            isPublished: r <| "is_published",
            createdAt: r <| "created_at"
        )
    }

    func escapedContext() -> [String: Node]{
        var context = [String: Node]()
        
        context = [
            "id": Node(id),
            "title": Node(SecureUtil.stringOfEscapedScript(html: title)),
            "content": Node(SecureUtil.stringOfEscapedScript(html: content)),
            "isPublished": Node(isPublished),
            "createdAt": Node(createdAt)
        ]

        return context
    }
}