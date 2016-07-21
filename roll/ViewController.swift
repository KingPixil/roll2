//
//  ViewController.swift
//  roll
//
//  Created by Kabir Shah on 7/21/16.
//  Copyright © 2016 Kabir Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var gradientLayer = CAGradientLayer()
    
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
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

