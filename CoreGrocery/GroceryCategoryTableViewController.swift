//
//  GroceryCategoryTableViewController.swift
//  CoreGrocery
//
//  Created by Efrain Ayllon on 7/23/16.
//  Copyright © 2016 Efrain Ayllon. All rights reserved.
//

import UIKit
import CoreData

class GroceryCategoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var managedObjectContext :NSManagedObjectContext!
    var fetchedResultsController :NSFetchedResultsController!


    
    @IBAction func addButtonPressed(){
        let alert = UIAlertController(title: "Add New Grocery Item", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print(textField.text!)
        
       
        
        
            let groceryCategory = NSEntityDescription.insertNewObjectForEntityForName("GroceryCategory", inManagedObjectContext: self.managedObjectContext)
            
            groceryCategory.setValue(textField.text, forKey: "title")
            
            try! self.managedObjectContext.save()

        
        
        }))
        
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest(entityName: "GroceryCategory")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
        try! self.fetchedResultsController.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break
            
        case .Delete:
            break
            
        case .Update:
            break
            
        case .Move:
            break
            
        }
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = self.fetchedResultsController.sections else {
            fatalError("Featched Results Error")
        }
        return categories[section].numberOfObjects
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let diarylist = self.fetchedResultsController.objectAtIndexPath(indexPath)
        cell.textLabel?.text = diarylist.valueForKey("title") as? String
        print()
        
        return cell
    
}
    

}
