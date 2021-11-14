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
//  Date: 12 November 2021
//  App name: TodoList
//  App Description: A simple todo list iOS application

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TodoTableView: UITableView!
    
    private let todoList = [
            "Grocery Shopping", "Android Assignment", "Laundary", "iOS Assignment"
        ]
    
        let simpleTableIdentifier = "TodoListTable"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Function for number of rows in table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    // Function for implementing cells of table view
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(
                style: UITableViewCell.CellStyle.subtitle,
                reuseIdentifier: simpleTableIdentifier)
        }
        
        //let image : UIImage = UIImage(named: "penIcon")!
        //cell?.imageView?.image = image
        
        cell?.textLabel?.text = todoList[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 24)
        
        // Adding details to table cells
        
        if indexPath.row == 0 {
            cell?.detailTextLabel?.text = "No due date"
            }
        else if indexPath.row == 1 {
            cell?.detailTextLabel?.text = "Overdue"
            cell?.detailTextLabel?.textColor = UIColor.red
            }
        else if indexPath.row == 2 {
            cell?.detailTextLabel?.text = "Completed"
            cell?.detailTextLabel?.textColor = UIColor.systemTeal
            }
        else {
            cell?.detailTextLabel?.text = "Sat November 13, 2021"
            }
        
        
        // Adding Switch Controls
        
        let swicthView = UISwitch(frame: .zero)
        
        if indexPath.row == 2 {
            swicthView.setOn(true, animated: true)
        }
        else{
            swicthView.setOn(false, animated: true)
        }
        swicthView.tag = indexPath.row
        swicthView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell?.accessoryView = swicthView
        
        return cell!
    }
    
    // Function for switch changed
    
    @objc func switchChanged(_ sender: UISwitch!) {
        
        print("Table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
    }


}

