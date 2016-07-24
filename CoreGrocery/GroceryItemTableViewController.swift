//
//  GroceryItemTableViewController.swift
//  CoreGrocery
//
//  Created by Efrain Ayllon on 7/23/16.
//  Copyright © 2016 Efrain Ayllon. All rights reserved.
//

import UIKit
import CoreData

class GroceryItemTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext :NSManagedObjectContext!
    var groceryCategory :NSManagedObject!
    var fetchedResultsController :NSFetchedResultsController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = groceryCategory.valueForKey("title") as? String
        let fetchRequest = NSFetchRequest(entityName: "GroceryItem")
        let sortByCategory = NSPredicate(format: "groceryCategory.title = %@", self.title!)
        fetchRequest.predicate = sortByCategory
        
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
        try! self.fetchedResultsController.performFetch()
        
        
        
        
        
        
        
        
    }
    

    
    @IBAction func addButtonPressed(){
        let alert = UIAlertController(title: "Add New Grocery Item", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print(textField.text!)
            
            let groceryItem = NSEntityDescription.insertNewObjectForEntityForName("GroceryItem", inManagedObjectContext: self.managedObjectContext)
            groceryItem.setValue(textField.text, forKey: "title")
            
            
            let groceryItems = self.groceryCategory.mutableSetValueForKey("groceryItems")
            
            groceryItems.addObject(groceryItem)
            
            
            try! self.managedObjectContext.save()
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break
            
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break

            
        case .Update:
            break
            
        case .Move:
            break
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.fetchedResultsController.sections else {
            fatalError("Featched Results Error")
        }
        return items[section].numberOfObjects
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath)
        let groceryItem = self.fetchedResultsController.objectAtIndexPath(indexPath)
        cell.textLabel?.text = groceryItem.valueForKey("title") as? String
        print()
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let deletePosts: NSManagedObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
            self.managedObjectContext.deleteObject(deletePosts)
            try! self.managedObjectContext.save()
        }
    }
}

