//
//  NewTaskController
//  roll
//
//  Created by Kabir Shah on 7/21/16.
//  Copyright © 2016 Kabir Shah. All rights reserved.
//

import UIKit

class NewTaskController: UIViewController, UITextFieldDelegate {

    @IBOutlet var popupView: UIView!
    @IBOutlet var taskTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 10
        popupView.layer.borderColor = UIColor.blackColor().CGColor
        popupView.layer.borderWidth = 0.25
        popupView.layer.shadowColor = UIColor.blackColor().CGColor
        popupView.layer.shadowOpacity = 0.6
        popupView.layer.shadowRadius = 15
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
        
        taskTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        
        return true
    }
    


}
