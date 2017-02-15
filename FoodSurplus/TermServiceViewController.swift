//
//  TermServiceViewController.swift
//  FoodSurplus
//
//  Created by Abhinav Ayalur on 2/9/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//
import FirebaseAuth
import Firebase
import UIKit
import FirebaseDatabase

class TermServiceViewController: UIViewController, UIImagePickerControllerDelegate {
    
    //var acceptance = 0
    var email = ""
    var password = ""
    
    var ref = FIRDatabase.database().reference(fromURL: "https://foodsurplus-503b4.firebaseio.com/")

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Accept(_ sender: Any) {
        print(email)
        print(password)
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {
            (user, error) in
            if error == nil{
                //print("sick")
                let uid = (user?.uid)!
                let values = ["email": self.email]
                let usersReference = self.ref.child("users").child(uid)
                usersReference.ref.updateChildValues(values, withCompletionBlock: { (error, ref)
                    in
                    if error != nil{
                        print(error)
                        return
                    }
                    
                })
                self.performSegue(withIdentifier: "TermsToProfileCreation", sender: self)
            }
            else{
                print(error)
                /*self.performSegue(withIdentifier: "TermToAuth", sender: self)*/
                
            }
            
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        
        if (segue?.identifier == "TermsToProfileCreation") {
            
            /* let auth = segue!.destination as! AuthenticationViewController
            auth.acceptance = acceptance */
            let prof = segue!.destination as! ProfileCreationViewController
            
        }
        else if (segue?.identifier == "TermToHome"){
        }
        
    }
    
    @IBAction func Decline(_ sender: Any) {
        self.performSegue(withIdentifier: "TermToAuth", sender: self)
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
