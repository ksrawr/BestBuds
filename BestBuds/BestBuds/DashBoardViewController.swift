//
//  DashBoardViewController.swift
//  BestBuds
//
//  Created by An Dao on 5/14/19.
//  Copyright © 2019 An Dao & Kenneth Surban. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class DashBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dashTable: UITableView!
    
    
    var databaseHandle: DatabaseHandle?
    var ref: DatabaseReference?
    
    var displayArray = [String]()
    var favoriteArray = [String]()
    var reviewArray = [String]()
    
    var favoriteLoaded = true
    var reviewLoaded = false
    
    
    @IBAction func backAction(_ sender: Any) {
        performSegue(withIdentifier: "DashToHome", sender: self)
    }
    
    @IBAction func loadReviews(_ sender: Any) {
        displayArray.removeAll()
        displayArray = reviewArray
        self.dashTable.reloadData()
    }
    
    @IBAction func loadFavorites(_ sender: Any) {
        displayArray.removeAll()
        displayArray = favoriteArray
        self.dashTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return displayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let display = displayArray[indexPath.row]
        let cell = dashTable.dequeueReusableCell(withIdentifier: "dashCell") as! DashBoardTableViewCell
        cell.titlelabel.text = display
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dashTable.delegate = self
        dashTable.dataSource = self
        let user = Auth.auth().currentUser
        let displayName = user?.displayName
        
        
        ref = Database.database().reference()
        
        // getting Favorites
        databaseHandle = ref?.child("Favorites").child(displayName!).observe(.childAdded, with: {snapshot in
            let favorite = snapshot.value as? String
            
            if let actualFavorite = favorite{
                self.favoriteArray.append(actualFavorite)
                self.displayArray = self.favoriteArray
               
            }
            
        })
        //getting Reviews
        let reviewsRef = ref?.child("Reviews")
        reviewsRef?.observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children{
                let reviewSnap = child as! DataSnapshot
                let reviewDict = reviewSnap.value as! [String: Any]
                let userName = reviewDict["username"] as? String
                print(userName as Any)
                let reviewContent = reviewDict["content"] as? String
                let strainName = reviewDict["strain"] as? String
                if (user?.email == userName){
                    //print(reviewContent)
                    let review = strainName! + ": " + reviewContent!
                    self.reviewArray.append(review)
                    
                }
            }
        })
        
        
        
       

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
