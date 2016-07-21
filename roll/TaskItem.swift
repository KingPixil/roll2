//
//  TaskItem.swift
//  roll
//
//  Created by Kabir Shah on 7/21/16.
//  Copyright © 2016 Kabir Shah. All rights reserved.
//

import UIKit

class TaskItem: NSObject {
    var text: String
    
    var completed: Bool
    
    init(text: String) {
        self.text = text.uppercaseString
        self.completed = false
    }
}
