//
//  Todo.swift
//  Author: Shrinal Patel
//  Student id: 301204864
//  Author: Akash Sharma
//  Student id: 301211702
//  Author: Vidhu Gaba
//  Student id: 301210694
//
//  Date: 27 November 2021
//  App name: TodoList
//  App Description: A simple todo list iOS application
//

import Foundation
import CoreData

@objc(Todo)
class Todo: NSManagedObject
{
    @NSManaged var id: String!
    @NSManaged var name: String!
    @NSManaged var desc: String!
    @NSManaged var dueDate: Date?
    @NSManaged var deletedDate: Date?
}
