//
//  TableViewCell.swift
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

import UIKit
import CoreData

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoName: UILabel!
    
    @IBOutlet weak var todoStatus: UILabel!
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    var selectedTodo: Todo? = nil
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func mySwitchTap(_ sender: UISwitch) {
        // Getting UISwitch current status
        let switchStatus:Bool = sender.isOn
        
        if(switchStatus){
            mySwitch.setOn(false, animated: true)
        }
        else{
            mySwitch.setOn(true, animated: true)
        }

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            do {
                let navigationController = self.window?.rootViewController as! UINavigationController
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let todo = result as! Todo
                    if(todo == selectedTodo)
                    {
                        todo.deletedDate = Date()
                        try context.save()
                        navigationController.popViewController(animated: true)
                    }
                }
            }
            catch
            {
                print("Fetch Failed")
            }
    }
    
}
