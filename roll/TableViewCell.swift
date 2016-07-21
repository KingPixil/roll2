//
//  TableViewCell.swift
//  roll
//
//  Created by Kabir Shah on 7/21/16.
//  Copyright © 2016 Kabir Shah. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func deleteTaskItem(taskItem: TaskItem)
}

class TableViewCell: UITableViewCell {
    
    var taskItem: TaskItem?
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var delegate: TableViewCellDelegate?
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        var recognizer = UIPanGestureRecognizer(target: self, action: Selector("handleDeletePan:"))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    
    func handleDeletePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0 || frame.origin.x > -frame.size.width / 2.0
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease {
                // if the item is not being deleted, snap back to the original location
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
            
            if deleteOnDragRelease {
                if delegate != nil && taskItem != nil {
                    delegate!.deleteTaskItem(taskItem!)
                }
            }
        }
    }
    

}
