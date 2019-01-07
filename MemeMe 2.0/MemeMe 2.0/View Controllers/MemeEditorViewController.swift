//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by André Sanches Bocato on 07/11/18.
//  Copyright © 2018 André Sanches Bocato. All rights reserved.
//

// @TODO: capitalyze all characters in the textfields (works on simulator, doesn't work on device)
// @TODO: center textField.text

import UIKit

class MemeEditorViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

// MARK: - Properties
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let textFieldsDelegate = TextFieldsDelegate()
    let bottomTextDelegate = TextFieldsDelegate()
    
    var lastMeme: Meme?
    
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfieldsConfig(textField: topTextField, text: "TOP")
        setTextfieldsConfig(textField: bottomTextField, text: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            cameraButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
// MARK: - Buttons
    
    @IBAction func pickImage(_ sender: UIButton) {
        selectImagePickerSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        selectImagePickerSourceType(sourceType: .camera)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let imageToShare = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: [])
        activityViewController.completionWithItemsHandler = { (activityType, isCompleted, returnedItems, error) in
            if !isCompleted || error != nil {
                return
            }
            self.saveImage()
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
// MARK: - Functions

    func setTextfieldsConfig(textField: UITextField, text: String) {
        textField.text = text
        textField.autocapitalizationType = .allCharacters            // didn't work on iphone 5S
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = textFieldsDelegate
    }
    
    func selectImagePickerSourceType(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        hideNavigationBarAndToolbar()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        showNavigationBarAndToolbar()
        
        return memedImage
    }
    
    func hideNavigationBarAndToolbar() {
        toolbar.isHidden = true
        navigationBar.isHidden = true
    }
    
    func showNavigationBarAndToolbar() {
        toolbar.isHidden = false
        navigationBar.isHidden = false
    }
    
    func saveImage() {
        // Create the meme
        let memedImage = generateMemedImage()
        let readyMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)

        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(readyMeme)
    }
    
    // Mark: - Text Attributes
    
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5.0]
}
