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
        
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        if launchedBefore  {
            print("Welcome Back")
        }
        else {
            print("First launch, showing Instructions.")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
        }
        
        // background gradient
        self.view.backgroundColor = UIColor.blackColor()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(red:0.14, green:0.78, blue:0.86, alpha:1.0).CGColor as CGColorRef
        let color2 = UIColor(red:0.14, green:0.86, blue:0.65, alpha:1.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, atIndex:0)
        
        // styles for cell
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        
        // init table view
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        // start
        updateTasks()
        
    }
    
    
    // lock orientation at portrait
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

    
    
    
    
    
    
    
    // make status bar hidden for "full screen" effect
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    
    
    
    
    
    
    
    // dim background for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dim(.In, alpha: dimLevel, speed: dimSpeed)
    }
    
    // undim background and update table when coming back from segue
    @IBAction func unwindFromNewTask(segue: UIStoryboardSegue) {
        dim(.Out, speed: dimSpeed)
        updateTasks()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // when view is dragged down, do the following:
    //      1) play sound
    //      2) show new task segue
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // check whether the user pulled down far enough
        if -scrollView.contentOffset.y > tableView.rowHeight {
            AudioServicesPlaySystemSound(systemSoundId)
            performSegueWithIdentifier("newTaskSwipe", sender: scrollView)
        }
    }

    
    
    
    
    
    
    
    
    // UTIL FUNCTIONS FOR STORAGE
    
    
    
    func addTaskItem(task: String) {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("TaskItem", inManagedObjectContext: self.managedObjectContext) as! TaskItem
        
        newItem.task = task
        updateTasks()
    }
    
    func deleteTaskItem(taskItem: TaskItem) {
        let index = (taskItems! as NSArray).indexOfObject(taskItem)
        if index == NSNotFound { return }
        
        managedObjectContext.deleteObject(taskItems![index])
        taskItems!.removeAtIndex(index)
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
            return taskItems!
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
            return nil
        }
    }
    

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateTasks()
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

