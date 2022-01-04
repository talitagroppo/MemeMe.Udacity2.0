//
//  MemeImagePickerView.swift
//  MemeTwo
//
//  Created by Talita Groppo on 22/12/2021.
//

import Foundation
import UIKit

class MemeImagePickerView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    static let identifier = "MemeImagePickerView"
    
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var bottomBarButton: UIToolbar!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet var senderImage: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    
    let storage = MemeStorage()
    
    lazy var allMemes: [Meme] = {
        return storage.load()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.tabBarController?.tabBar.isHidden = true
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        senderImage.isEnabled = false
        textFields()
    }
    @IBAction func cancelEvent(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func senderImage(_ sender: UIBarButtonItem) {
        let showImage = generateMemedImage()
        guard let image = imagePicker.image else { return }
        guard let topText = topText.text else { return }
        guard let bottomText = bottomText.text else { return }
        let controller = UIActivityViewController(activityItems: [image, topText, bottomText], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activity, completed, items, error) in
            if completed {
                self.saveImage(showImage)
            } else {
                return
            }
        }
        controller.popoverPresentationController?.sourceView = self.view
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickerImage(_ sender: UIBarButtonItem) {
        if (sender == camera){
        sourceController(controller: .camera)
    } else {
        sourceController(controller: .photoLibrary)
    }
    }
    
    @IBAction func saveImage(_ sender: UIImage) {
        let imageToSave = generateMemedImage()
        let data = imageToSave.jpegData(compressionQuality: 0.5)
        let filename = "\(UUID()).jpg"
        let path = getDirectory().appendingPathComponent(filename)
        do {
            try data?.write(to: path)
            let meme = Meme(top: topText.text!, bottom: bottomText.text!, imagePath: filename)
            storage.save(meme: meme)
        } catch {
            print(error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        senderImage.isEnabled = true
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicker.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func sourceController(controller: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = controller
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        isHide(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        isHide(false)
        return memedImage
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func isHide(_ isHideBottom: Bool){
        bottomBarButton.isHidden = isHideBottom
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -3.0
        ]
        textField.defaultTextAttributes = textFieldAttributes
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFields(){
        setupTextField(topText, text: "TOP")
        setupTextField(bottomText, text: "BOTTOM")
        
    }
    
    func setupTextField(_ textField: UITextField, text: String){
        textField.delegate = self
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10.0
        textField.text = text
        
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
