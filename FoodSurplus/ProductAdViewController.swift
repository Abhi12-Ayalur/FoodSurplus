//
//  ProductAdViewController.swift
//  Pods
//
//  Created by Abhinav Ayalur on 2/14/17.
//
//

import UIKit
import Firebase
import FirebaseStorage
import CoreLocation

class ProductAdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    let x = CLLocationManager()
    let encode = CLGeocoder()
    var typeName = ""
    let ref = FIRDatabase.database().reference()
    let imagePicker = UIImagePickerController()
    var itemJPG: Data!
    var username: String = ""
    var firstname: String = ""
    var lastname: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zipcode: String = ""
    var locationArray: Array<Any> = ["",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dict = snapshot.value as? NSDictionary{
                self.username = dict["username"] as! String
                self.firstname = dict["firstname"] as! String
                self.lastname = dict["lastname"] as! String
                self.address = dict["address"] as! String
                self.city = dict["city"] as! String
                self.state = dict["state"] as! String
                self.zipcode = dict["zipcode"] as! String
            }
            
        })
        let fullAddress = "United States, \(city), \(address)"

        encode.geocodeAddressString(fullAddress, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.locationArray[0] = coordinates.latitude
                self.locationArray[1] = coordinates.longitude
                print("lat", coordinates.latitude)
                print("long", coordinates.longitude)
            }
        })
    }
        // Do any additional setup after loading the view.
        
    @IBOutlet weak var ItemImage: UIImageView!
    
    
    
    @IBOutlet weak var ImageSelectButton: UIButton!
    
    @IBOutlet weak var ItemName: UITextField!
    @IBOutlet weak var ItemDescription: UITextView!
    @IBOutlet weak var TypeStatic: UIButton!
    @IBAction func ImageSelect(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        {
        }
        ImageSelectButton.setTitle("Change Image", for: .normal)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ItemImage.contentMode = .scaleAspectFit
            ItemImage.image = pickedImage
            itemJPG = UIImageJPEGRepresentation(pickedImage, 0.8)
            
        }
        else{
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    @IBAction func SubmitItem(_ sender: Any) {
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        let itemName = ItemName.text!
        
        
        let locationPart = self.locationArray[0]
        let locationPart2 = self.locationArray[1]
        let locationString = "\(locationPart)\(locationPart2)"
        let imageName = itemName + locationString + ".jpg"
        let infoStorage: Array = [itemName, ItemDescription.text!, locationArray, uid] as [Any]
        let itemValues = [itemName: infoStorage] as [String : Any]
        self.ref.child("items").updateChildValues(itemValues, withCompletionBlock: { (error, ref)
            in
            if error != nil{
                print(error)
                return
            }
        })
        self.ref.child("userItems").child(uid!).updateChildValues(itemValues, withCompletionBlock:{ (error, ref)
            in
            if error != nil{
                print(error)
                return
            }
        })

        let storageRef = FIRStorage.storage().reference().child("userItems").child(uid!).child(imageName)
        
        let secondStorageRef = FIRStorage.storage().reference().child("items").child(locationString).child(imageName)
        let itemPicMetaData = FIRStorageMetadata()
        itemPicMetaData.contentType = "image/jpeg"
        /* let productUpload = storageRef.put(itemJPG as Data, metadata: itemPicMetaData) {
            (metadata, error) in
            if error != nil {
                print("error")
                return
            }
        } */
        let productLocationUpload = secondStorageRef.put(itemJPG as Data, metadata: itemPicMetaData) {
            (metadata, error) in
            if error != nil {
                print("error")
                return
            }
        }
        print("addition of item is success")

        performSegue(withIdentifier: "AddedProduct", sender: self)
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
