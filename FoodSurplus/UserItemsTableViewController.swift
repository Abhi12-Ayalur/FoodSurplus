//
//  UserItemsTableViewController.swift
//  FoodSurplus
//
//  Created by Abhinav Ayalur on 2/19/17.
//  Copyright © 2017 Abhinav Ayalur. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import CoreLocation

class userItemCell: UITableViewCell{
    @IBOutlet weak var userItemLabel: UILabel!
    @IBOutlet weak var userItemImage: UIImageView!
    
}

class UserItemsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()

    let storageRef = FIRStorage.storage().reference()
    var i = 0
    var localUserItems: Array<String> = []
    var localUserItemData: Array<Array<Any>> = []
    var imageData: Array<Data> = []
    var username: String = ""
    var firstname: String = ""
    var lastname: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zipcode: String = ""
    var locationArray: Array<Any> = ["", ""]
    var passVar = 0
    
    let x = CLLocationManager()
    let encode = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid

        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
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
                //print(coordinates.latitude)
                self.locationArray[0] = coordinates.latitude
                self.locationArray[1] = coordinates.longitude
                //print("lat", coordinates.latitude)
                //print("long", coordinates.longitude)
            }
        })

        ref.child("userItems").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot]{
                //print (rest.value!)
                self.localUserItemData.append([rest.value!])
                //print(self.localUserItemData)
                let dataArray = self.localUserItemData[self.i]
                let dataVal = dataArray[0] as! Array<Any>
                print(dataVal[0])
                self.localUserItems.append(dataVal[0] as! String )
                self.i += 1
            }
            print(self.localUserItemData)
            print(self.localUserItems)
            self.passVar = 1
        })
        while self.passVar == 0{
            var meme = ""
            print(meme)
        }
        print("finished database")
        if self.passVar == 1{
        let locationPart = self.locationArray[0]
        let locationPart2 = self.locationArray[1]
        let locationString = "\(locationPart)\(locationPart2)"
        var itemStorageRef = storageRef.child("items")
        var size = self.localUserItems.count
        print(size)
        size = size - 1
        if size > 0{
        for n in 0...size{
            let storageString = self.localUserItems[n] + locationString + ".jpg"
            let imageItemRef = itemStorageRef.child(storageString)
            imageItemRef.data(withMaxSize: 1 * 2048 * 2048) { data, error in
                if let error = error {
                    print(error)
                } else {
                    // Data for "images/island.jpg" is returned
                    self.imageData[n] = data!
                }
            }
            }
            print("reloading")
            self.tableView.delegate = self
            self.tableView.dataSource = self
            tableView.reloadData()
            }
        }
        /*let storageRef = FIRStorage.storage()
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
            }*/
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(self.localUserItems.count)
        return self.localUserItems.count
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("doing")
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! userItemCell
        let data = self.imageData[indexPath.row]
        let name = self.localUserItems[indexPath.row]
        //print(name)
        cell.userItemLabel.text! = name as! String
        let image = UIImage(data: data)
        cell.userItemImage.contentMode = .scaleAspectFit
        cell.userItemImage.image = image
        // Configure the cell...
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let ref = FIRDatabase.database().reference()
        let storageRef = FIRStorage.storage().reference().child("items")
        let userID = FIRAuth.auth()?.currentUser?.uid
        if editingStyle == .delete {
            // Delete the row from the data source
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! userItemCell
            let deleteLabel = cell.userItemLabel.text!
            let deleteImage = cell.userItemImage.image
            let receivedLocation: Array = [] as! Array
            
            
            
            ref.child("userItems").child(userID!).child(deleteLabel).removeValue()
            
            ref.child("items").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    /*self.localUserItems[self.i] = rest.value! as! String
                    self.i += 1*/
                    let itemValues = rest.value! as! Array<Any>
                    if itemValues[0] as! String == deleteLabel{
                        let userIDString = userID! as! String
                        if itemValues[3] as! String == userIDString{
                            //rest.ref.removeValue()
                            let locationArray = itemValues[2] as! Array<Any>
                            let locationPart = locationArray[0]
                            let locationPart2 = locationArray[1]
                            let locationString = "\(locationPart)\(locationPart2)"
                            let pathString = deleteLabel + locationString + ".jpg"
                            storageRef.child(pathString).delete { error in
                                if let error = error {
                                    // Uh-oh, an error occurred!
                                } else {
                                    // File deleted successfully
                                }
                            }
                            rest.ref.child(rest.key).parent?.removeValue()
                        }
                    }
                    
                }
            })
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } /* else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    */
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
