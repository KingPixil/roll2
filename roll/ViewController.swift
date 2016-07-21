//
//  ViewController.swift
//  roll
//
//  Created by Kabir Shah on 7/21/16.
//  Copyright © 2016 Kabir Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var gradientLayer = CAGradientLayer()
    var taskItems = [TaskItem]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // separator style none
        tableView.separatorStyle = .None
        
        // background gradient
        self.view.backgroundColor = UIColor.blackColor()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(red: 0.20, green: 0.56, blue: 0.31, alpha: 1.0).CGColor as CGColorRef
        let color2 = UIColor(red: 0.34, green: 0.71, blue: 0.83, alpha: 1.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, atIndex:0)
        
        // default content
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if taskItems.count > 0 {
            return
        }
        taskItems.append(TaskItem(text: "here are your tasks"))
        taskItems.append(TaskItem(text: "swipe down to create one"))
        taskItems.append(TaskItem(text: "swipe left or right to delete"))
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let item = taskItems[indexPath.row]
        cell.textLabel?.text = item.text
        return cell
    }

}

