//
//  ProfileMainViewController.swift
//  FoodSurplus
//
//  Created by Abhinav Ayalur on 2/12/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileMainViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBAction func UsernameEdited(_ sender: UITextField) {
        let username = UsernameStatic.text!
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).updateChildValues(["username": username])
    }
    
    @IBOutlet weak var UsernameStatic: UITextField!
    
    @IBOutlet weak var FirstNameStatic: UITextField!
    
    @IBAction func FirstNameEdited(_ sender: UITextField) {
        var firstName = FirstNameStatic.text!
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).updateChildValues(["firstname": firstName])
    }
    
    @IBOutlet weak var LastNameStatic: UITextField!
    
    
    @IBAction func LastNameEdited(_ sender: UITextField) {
        let lastName = LastNameStatic.text!
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).updateChildValues(["lastname": lastName])
    }
    
    @IBOutlet weak var AddressStatic: UITextField!
    
    
    @IBAction func AddressEdited(_ sender: UITextField) {
        let address: String = AddressStatic.text!
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).updateChildValues(["address": address])
        /*let zipUpdate: NSString = address as NSString
        updateRef.updateChildValues(address)*/
    }
    
    @IBOutlet weak var CityStatic: UITextField!
    
    @IBAction func CityEdited(_ sender: UITextField) {
        let city = CityStatic.text!
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).updateChildValues(["city": city])
    }
    
    @IBOutlet weak var StateStatic: UITextField!
    
    @IBAction func StateEdited(_ sender: UITextField) {
        let state = StateStatic.text!
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).updateChildValues(["state": state])
    }
    
    @IBOutlet weak var ZipCodeStatic: UITextField!
    
    @IBAction func ZipEdited(_ sender: UITextField) {
        let zipCode = ZipCodeStatic.text!
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).updateChildValues(["zipcode": zipCode])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dict = snapshot.value as? NSDictionary{
                self.UsernameStatic.text! = dict["username"] as! String
                self.FirstNameStatic.text! = dict["firstname"] as! String
                self.LastNameStatic.text! = dict["lastname"] as! String
                self.AddressStatic.text! = dict["address"] as! String
                self.CityStatic.text! = dict["city"] as! String
                self.StateStatic.text! = dict["state"] as! String
                self.ZipCodeStatic.text! = dict["zipcode"] as! String
            }
            
        })
        let storageRef = FIRStorage.storage()
        let storageString = "users/" + userID! + "/profile.jpg"
        let pathReference = storageRef.reference(withPath: storageString)
        let islandRef = storageRef.reference().child(storageString)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.data(withMaxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                print("imagedata transferred")
                self.ProfileImage.contentMode = .scaleAspectFit
                self.ProfileImage.image = image
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
