//
//  AuthenticationViewController.swift
//  FoodSurplus
//
//  Created by Abhinav Ayalur on 2/7/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func infoButton(_ sender: UIButton) {
        
    }
    @IBOutlet weak var loginStatic: UIButton!
    @IBAction func loginSender(_ sender: UIButton) {
        FIRAuth.auth()?.signIn(withEmail: EmailText.text!, password: PasswordText.text!) { (user, error) in
            // ...
            print("wew")
        }
    }
    @IBOutlet weak var signupStatic: UIButton!
    @IBAction func signupSender(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: EmailText.text!, password: PasswordText.text!) { (user, error) in
            // ...
        }
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
