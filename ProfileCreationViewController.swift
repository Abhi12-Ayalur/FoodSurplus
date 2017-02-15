//
//  ProfileCreationViewController.swift
//  FoodSurplus
//
//  Created by Abhinav Ayalur on 2/10/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ProfileCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //var ref: FIRDatabaseReference!
    
    var profJPG: Data!
    let ref = FIRDatabase.database().reference(fromURL: "https://foodsurplus-503b4.firebaseio.com/")
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        print(uid)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadProfPicButtonTapped(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profImage.contentMode = .scaleAspectFit
            profImage.image = pickedImage
            profJPG = UIImageJPEGRepresentation(pickedImage, 0.8)
            
        }
        else{
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var profImage: UIImageView!
    
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var FirstName: UITextField!
    
    @IBOutlet weak var Address: UITextField!
    
    @IBOutlet weak var LastName: UITextField!

    @IBOutlet weak var City: UITextField!
    
    @IBOutlet weak var State: UITextField!
    
    @IBOutlet weak var ZipCode: UITextField!
    
    @IBAction func GoToHome(_: UIButton) {
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        let storageRef = FIRStorage.storage().reference().child("users").child(uid!).child("profile.jpg")
        let profPicMetaData = FIRStorageMetadata()
        profPicMetaData.contentType = "image/jpeg"
        let profileUpload = storageRef.put(profJPG as Data, metadata: profPicMetaData) {
            (metadata, error) in
            if error != nil {
                print("error")
                return
            }
        }
        
        let imagesRef = storageRef.child("users").child(uid!)
        
        let values = ["username": Username.text!, "firstname": FirstName.text!, "lastname": LastName.text!, "address": Address.text!, "city": City.text!, "state": State.text!, "zipcode": ZipCode.text!] as [String : Any]
        let usersReference = self.ref.child("users").child(uid!)
        usersReference.ref.updateChildValues(values, withCompletionBlock: { (error, ref)
            in
            if error != nil{
                print(error)
                return
            }
            
        })
        self.performSegue(withIdentifier: "ProfCreateToHome", sender: self)

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
