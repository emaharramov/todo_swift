import UIKit
import CoreData

class CoreDataHelper {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    func fetchItems() -> [TodoItem] {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let items = try? context.fetch(request)
        return items ?? []
    }
    
    
    func searchItems(searchText: String) -> [TodoItem] {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        request.predicate = predicate
        let items = try? context.fetch(request)
        return items ?? []
    }

    func addItem(title: String) {
        let newItem = TodoItem(context: context)
        newItem.title = title
        try? context.save()
    }
    
    func updateItem(item: TodoItem, newTitle: String) {
        item.title = newTitle
        try? context.save()
    }
    
    func deleteItem(item: TodoItem) {
        context.delete(item)
        try? context.save()
    }
}
