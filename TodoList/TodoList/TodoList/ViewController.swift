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
//  Date: 12 December 2021
//  App name: TodoList
//  App Description: A simple todo list iOS application

import UIKit
import CoreData

var todoList = [Todo]()
var todos: [NSManagedObject] = []


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var TodoTableView: UITableView!
    @IBOutlet weak var mySwitch: UISwitch!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        TodoTableView.reloadData()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Todo")
          
          do {
            todos = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch todos. \(error), \(error.userInfo)")
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
        cell.todoStatus.text = "Incomplete"
        
        return cell
    
    }
    
    // Function for swiping left and deleting a todo
    
    private func deleteTodo(indexPath: IndexPath) {
        TodoTableView.beginUpdates()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(todos[indexPath.row])
        do {
            try managedContext.save()
            todos.remove(at: indexPath.row)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        TodoTableView.deleteRows(at: [indexPath], with: .fade)
        TodoTableView.endUpdates()    }
    
    //Function for swiping left and marking a todo completed
    
    private func completeTodo(indexPath: IndexPath) {
        print("complete")
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let isCompleted = todos[indexPath.row].value(forKey: "isCompleted") as! Bool
        todos[indexPath.row].setValue(!isCompleted, forKey: "isCompleted")
    
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
        print("Todo updated")
        TodoTableView.reloadData()
        
    }
    
    //Swipe right function for editing a todo
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let editTodoSwipe = UIContextualAction(style: .normal, title: "Edit")
        {
            action, view, edit in
            
            let editTodoDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editTodo") as! DetailsViewController
    
            let transition:CATransition = CATransition()
                    transition.duration = 0.5
                    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    transition.type = .push
                    transition.subtype = .fromLeft

            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            
            self.navigationController?.pushViewController(editTodoDetails, animated: true)
        }

        editTodoSwipe.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [editTodoSwipe])
    }
    
    //Swipe left function for deleting and marking a todo completed
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completeTodoSwipe = UIContextualAction(style: .normal,
                                       title: "Complete")
        { [weak self] (action, view, completionHandler) in
            self?.completeTodo(indexPath: indexPath)
        completionHandler(true)
        }


        let deleteTodoSwipe = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] (action, view, completionHandler) in
            self?.deleteTodo(indexPath: indexPath)
            completionHandler(true)
            
            /*let point = (sender as AnyObject).convert(CGPoint.zero, to: self?.TodoTableView)
            //guard let indexpath = self?.TodoTableView.indexPathForRow(at: point) else {return}
            
            self?.TodoTableView.beginUpdates()
            todoList.remove(at: indexPath.row)
            self?.TodoTableView.reloadData()
            self?.TodoTableView.deleteRows(at: [IndexPath(row: 2, section: 1)], with: .fade)
            self?.TodoTableView.endUpdates()*/
            
            
        }
    
        completeTodoSwipe.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions: [deleteTodoSwipe, completeTodoSwipe])
        
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


