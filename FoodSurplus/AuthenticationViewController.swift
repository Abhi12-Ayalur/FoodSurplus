//
//  AuthenticationViewController.swift
//  FoodSurplus
//
//  Created by Abhinav Ayalur on 2/7/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import QuartzCore
import FirebaseAuth
class AuthenticationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func infoButton(_ sender: UIButton) {
        let infoPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "infoPopUpID") as! InfoPopUpViewController
        self.addChildViewController(infoPopUpVC)
        infoPopUpVC.view.frame = self.view.frame
        self.view.addSubview(infoPopUpVC.view)
        infoPopUpVC.didMove(toParentViewController: self)
    }
    @IBOutlet weak var loginStatic: UIButton!
    @IBAction func loginSender(_ sender: UIButton) {
        FIRAuth.auth()?.signIn(withEmail: EmailText.text!, password: PasswordText.text!, completion: {
            (user, error) in
            if user != nil{
                self.performSegue(withIdentifier: "GoToHome", sender: self)
            }
            else{
                print(error)
            }
            
            
        })
    }
    func none() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    @IBOutlet weak var FoodSurplus: UILabel!
    @IBOutlet weak var signupStatic: UIButton!
    @IBAction func signupSender(_ sender: UIButton) {
        self.performSegue(withIdentifier: "AuthToTerm", sender: self)
    
        }
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        
        if (segue?.identifier == "AuthToTerm") {
            let auth = segue!.destination as! TermServiceViewController
            auth.email = EmailText.text!
            auth.password = PasswordText.text!
            
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
}
