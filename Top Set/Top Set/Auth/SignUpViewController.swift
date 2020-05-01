//
//  SignUpViewController.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePicker: UIImagePickerController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)

        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

    }
    
    func setupUI(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.alpha = 0.7;
        backgroundImage.addSubview(blurEffectView)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: fullNameTextField.frame.height - 1, width: fullNameTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.systemGreen.cgColor
        fullNameTextField.borderStyle = UITextField.BorderStyle.none
        fullNameTextField.layer.addSublayer(bottomLine)

        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: usernameTextField.frame.height - 1, width: usernameTextField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.systemGreen.cgColor
        usernameTextField.borderStyle = UITextField.BorderStyle.none
        usernameTextField.layer.addSublayer(bottomLine2)
        
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0.0, y: passwordTextField.frame.height - 1, width: passwordTextField.frame.width, height: 1.0)
        bottomLine3.backgroundColor = UIColor.systemGreen.cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(bottomLine3)

        let bottomLine4 = CALayer()
        bottomLine4.frame = CGRect(x: 0.0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 1.0)
        bottomLine4.backgroundColor = UIColor.systemGreen.cgColor
        emailTextField.borderStyle = UITextField.BorderStyle.none
        emailTextField.layer.addSublayer(bottomLine4)

        signUpButton.layer.cornerRadius = 10
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        fullNameTextField.attributedPlaceholder = NSAttributedString(string:"Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleSignUp(){
        guard let image = profileImageView.image else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        
        if image == UIImage(named: "defaultUser_small.png") || image == UIImage(named: "defaultUser"){
            let alertController = UIAlertController(title: "Error", message: "Custom picture is required", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
                       
            return
        }
        
        if fullNameTextField.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message:
                "Full name is required", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        if usernameTextField.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message:
                "Username is required", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        if emailTextField.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message:
                "Email is required", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        
        
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User created!")
                //self.performSegue(withIdentifier: "accountCreated", sender: self)
                
                // 1. Upload the profile image to Firebase Storage
                
                self.uploadProfileImage(image) { url in
                    
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("User display name changed!")
                                
                                self.saveProfile(fullName: fullName, username: username, profileImageURL: url!, email: email) { success in
                                    if success {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                                
                            } else {
                                print("Error: \(error!.localizedDescription)")
                                let alertController = UIAlertController(title: "Error", message:
                                    error!.localizedDescription, preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    } else {
                        // Error unable to upload profile image
                    }
                    
                }
                
            } else {
                print("Error: \(error!.localizedDescription)")
                let alertController = UIAlertController(title: "Error", message:
                    error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
            }
        }
    
    } // end signup
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let storageRef = Storage.storage().reference().child("user/\(uid)")
            
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
            
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
            storageRef.downloadURL { url, error in
                completion(url)
                // success!
                }
            } else {
                // failed
                completion(nil)
                }
            }
        }
    
    func saveProfile(fullName: String, username:String, profileImageURL:URL, email: String, completion: @escaping ((_ success:Bool)->())) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let databaseRef = Database.database().reference().child("users/profile/\(uid)")
            
            let userObject = [
                "fullName": fullName,
                "username": username,
                "photoURL": profileImageURL.absoluteString,
                "email": email,
                "timestamp": [".sv":"timestamp"],
            ] as [String:Any]
            
            databaseRef.setValue(userObject) { error, ref in
                completion(error == nil)
            }
        }
    
    
} // end VC

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}



