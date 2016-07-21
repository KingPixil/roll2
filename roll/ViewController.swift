//
//  ViewController.swift
//  roll
//
//  Created by Kabir Shah on 7/21/16.
//  Copyright © 2016 Kabir Shah. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TableViewCellDelegate, Dimmable {
    
    var gradientLayer = CAGradientLayer()
    var taskItems: [TaskItem]?
    
    let systemSoundId: SystemSoundID = 1117
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // styles for cell
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        
        // background gradient
        self.view.backgroundColor = UIColor.blackColor()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(red:0.14, green:0.78, blue:0.86, alpha:1.0).CGColor as CGColorRef
        let color2 = UIColor(red:0.14, green:0.86, blue:0.65, alpha:1.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, atIndex:0)
        
        // default content
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        let defaultItem = NSEntityDescription.insertNewObjectForEntityForName("TaskItem", inManagedObjectContext: self.managedObjectContext) as! TaskItem
        
        defaultItem.task = "Swipe down to create, swipe left/right to delete"
        updateTasks()
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dim(.In, alpha: dimLevel, speed: dimSpeed)
    }
    
    @IBAction func unwindFromNewTask(segue: UIStoryboardSegue) {
        dim(.Out, speed: dimSpeed)
    }
    
    func addTaskItem(task: String) {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("TaskItem", inManagedObjectContext: self.managedObjectContext) as! TaskItem
        
        newItem.task = task
        
        updateTasks()
    }
    
    func deleteTaskItem(taskItem: TaskItem) {
        let index = (taskItems! as NSArray).indexOfObject(taskItem)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        //taskItems!.removeAtIndex(index)
        
        managedObjectContext.deleteObject(taskItems![index])
        updateTasks()
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
        
    }
    
    func updateTasks() -> [TaskItem]? {
        do {
            let fetchRequest = NSFetchRequest(entityName: "TaskItem")
            let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [TaskItem]
            taskItems = fetchResults!
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            return taskItems!
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // check whether the user pulled down far enough
        if -scrollView.contentOffset.y > tableView.rowHeight {
            AudioServicesPlaySystemSound(systemSoundId)
            //refreshControl.endRefreshing()
            performSegueWithIdentifier("newTaskSwipe", sender: scrollView)
        }
    }
    

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskItems!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        let item = taskItems![indexPath.row]
        cell.textLabel?.text = item.task
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:13)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.backgroundColor = UIColor.clearColor()
        cell.delegate = self
        cell.taskItem = item
        
        return cell
    }

}

