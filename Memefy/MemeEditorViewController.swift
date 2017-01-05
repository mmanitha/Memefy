//
//  ViewController.swift
//  Memefy
//
//  Created by Michael Manisa on 12/13/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    //MARK: OUTLETS
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    //MARK: PROPERTIES
    
    let defaultTopText = "TOP TEXT"
    let defaultBottomText = "BOTTOM TEXT"
    var tempText: String? //variable to hold the default text of textfield so you can change text back if textfield is empty.
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
    
    
    // MARK: UI Functions
    
    enum UIState {
        case noImage, textFieldEditing, withImage
    }
    
    func configureUI(_ state: UIState) {
        switch(state) {
        case .noImage:
            shareButton.isEnabled = false
            cancelButton.isEnabled = false
            topBar.isHidden = false
            bottomBar.isHidden = false
        case .textFieldEditing:
            shareButton.isEnabled = false
            cancelButton.isEnabled = false
            topBar.isHidden = false
            bottomBar.isHidden = true
        case .withImage:
            shareButton.isEnabled = true
            cancelButton.isEnabled = true
            topBar.isHidden = false
            bottomBar.isHidden = false
        }
    }
    
    func checkforImageThenConfigureUI() {
        if imageView.image == nil {
            configureUI(.noImage)
        } else {
            configureUI(.withImage)
        }
    }
    
    
    //MARK: VC Lifecyle functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        configureTextField(textField: topTextField)
        configureTextField(textField: bottomTextField)
        
        checkforImageThenConfigureUI()
        
        //Lets you tap out of a textField
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    //Set text Field
    func configureTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    //Hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    //MARK: IMAGE PICKER FUNCTIONS
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            checkforImageThenConfigureUI()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        checkforImageThenConfigureUI()
    }
    
    
    //MARK: SHOW AND HIDE KEYBOARD AND MOVE VIEW
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }

    func subscribeToKeyboardNotifications() {
        //Subscribe to Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        //Unsubscribe from Keyboard Notifications
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK: TEXTFIELD FUNCTIONS
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        tempText = textField.text
        if (textField.text == defaultTopText || textField.text == defaultBottomText) {
            textField.text = ""
        }
        configureUI(.textFieldEditing)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" {
            textField.text = tempText
        } else {
            let userText = textField.text
            textField.text = userText
        }
        checkforImageThenConfigureUI()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pickImageFromAlbum(_ sender: AnyObject) {
        
        pickAnImageFromSource(source: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: AnyObject) {
        
        pickAnImageFromSource(source: .camera)
    }
    
    
    func pickAnImageFromSource(source: UIImagePickerControllerSourceType) {
        
        // code to pick an image from source
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        
        // generate memed image
        let finishedMeme = generateMemedImage()
        
        // provide memed image to activity VC
        let activityVC = UIActivityViewController(activityItems: [finishedMeme], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.save()
                let alert = UIAlertController(title: "Success!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if ((error) != nil) {
                let alert = UIAlertController(title: "Oh no!", message: "There was an error.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try again.", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        present(activityVC, animated: true, completion: nil)

    }
    
    
    //MARK: SAVE OUT MEME
    
    func generateMemedImage() -> UIImage {
        
        topBar.isHidden = true
        bottomBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topBar.isHidden = false
        bottomBar.isHidden = false
        
        return memedImage
    }
    
    func save() {

        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }

    
    //MARK: CANCEL
    
    @IBAction func cancel(_ sender: Any) {
        
        imageView.image = nil
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        checkforImageThenConfigureUI()
    }
    
}

