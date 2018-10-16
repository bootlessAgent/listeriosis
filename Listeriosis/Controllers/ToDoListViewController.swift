//
//  ViewController.swift
//  Listeriosis
//
//  Created by Eugene Trumpelmann on 2018/10/16.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    
    var itemArray = [Items]()
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        if let  items = defaults.array(forKey: "ListeriosisArray") as? [String] {
        //            itemArray = items
        
        
            loadData()
        
        //        if let items = defaults.array(forKey: "ListeriosisArray") as? [Item] {
        //            itemArray = items
        //        }
        
    }
    
    //MARK:  - TableView Datasource Methods
    
    
    //How many rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //Create a new reusable cell with name from storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator ===>
        //value = condition ? ValueIfTrue : ValueifFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - Tableview Delegate methods
    
    //what happens when cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new Items
    @IBAction func addListItemButton(_ sender: UIBarButtonItem) {
        
        //creates an alert
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        //create bigger scope textfield variable
        
        var textField = UITextField()
        
        //creates an action to take on alert button press
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens once user clicks add item button on UIAlert
            
            
            
            let newItem = Items(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveData()
            
        }
        //Add textfield to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
        }
        
        //calls new alert and adds action to it
        alert.addAction(action)
        
        
        
        //presents alert when action is pressed
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func saveData(){
        
        do {
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()    }
    
    func loadData(){
        
        let request : NSFetchRequest<Items> = Items.fetchRequest()
        
        do {
          itemArray =  try  context.fetch(request)
        }catch{
            print("Error loading context \(error)")
        }
    }
    
    
    
}


