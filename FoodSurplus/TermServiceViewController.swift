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

class TermServiceViewController: UIViewController {
    
    //var acceptance = 0
    var email = ""
    var password = ""

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
                self.performSegue(withIdentifier: "TermsToHome", sender: self)
            }
            else{
                print(error)
                self.performSegue(withIdentifier: "TermToAuth", sender: self)
                
            }
            
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        
        if (segue?.identifier == "TermToAuth") {
            
            /* let auth = segue!.destination as! AuthenticationViewController
            auth.acceptance = acceptance */
            
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
