//
//  TodoItem+CoreDataProperties.swift
//  todoApp
//
//  Created by Emil Maharramov on 27.09.24.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var title: String?

}

extension TodoItem : Identifiable {

}
