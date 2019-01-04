//
//  Top text delegate.swift
//  MemeMe tests1
//
//  Created by André Sanches Bocato on 13/11/18.
//  Copyright © 2018 André Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit

class TextFieldsDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
