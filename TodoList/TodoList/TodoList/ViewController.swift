//
//  ViewController.swift
//
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

import UIKit
import CoreData

var todoList = [Todo]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TodoTableView: UITableView!
    
    var firstLoad = true
    var selectedTodo: Todo? = nil
    
    // Function for non deleted todos
        
    func nonDeletedTodos() -> [Todo]
    {
        var noDeleteTodoList = [Todo]()
        for todo in todoList
        {
            if(todo.deletedDate == nil)
            {
                noDeleteTodoList.append(todo)
            }
        }
        return noDeleteTodoList
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodoTableView.delegate = self
        TodoTableView.dataSource = self
        TodoTableView.rowHeight = 69
        
        // On loading the ViewController for the first time
        
        if(firstLoad)
                {
                    firstLoad = false
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
                    do {
                        let results:NSArray = try context.fetch(request) as NSArray
                        for result in results
                        {
                            let todo = result as! Todo
                            todoList.append(todo)
                        }
                    }
                    catch
                    {
                        print("Fetch Failed")
                    }
                }
        
    }
    
    // Function for number of rows in table view
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedTodos().count
    }
    
    // Function for implementing cells of table view
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrototypeCell") as! TableViewCell
        
        let thisTodo: Todo!
        thisTodo = nonDeletedTodos()[indexPath.row]
        
        cell.todoName.text = thisTodo.name
        cell.todoStatus.text = thisTodo.desc
        cell.editButton.tag = indexPath.row
        
        return cell
    
    }
    
    override func viewDidAppear(_ animated: Bool)
        {
            TodoTableView.reloadData()
        }
    
    // Function for edit button
    
    @IBAction func editButtonTap(_ sender: UIButton) {
        selectedTodo = nonDeletedTodos()[sender.tag]
        self.performSegue(withIdentifier: "editTodo1", sender: nil)
    }
    
     // Function for after selecting a cell
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "editTodo", sender: self)
    }
    
    // Function for implementing segue to the DetailsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "editTodo")
        {
            let indexPath = TodoTableView.indexPathForSelectedRow!
            
            let todoDetail = segue.destination as? DetailsViewController
            
            let selectedTodo : Todo!
            selectedTodo = nonDeletedTodos()[indexPath.row]
            todoDetail!.selectedTodo = selectedTodo
            
            TodoTableView.deselectRow(at: indexPath, animated: true)
        }
        
    }


}

