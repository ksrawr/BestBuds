//
//  StrainViewController.swift
//  BestBuds
//
//  Created by Khoi Dao on 5/13/19.
//  Copyright © 2019 An Dao & Kenneth Surban. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class StrainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var reviewField: UITextView!
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?

    @IBAction func backAction(_ sender: Any) {
        performSegue(withIdentifier: "GoBackToSearch", sender: self)
    }
    @IBAction func AddToFavorites(_ sender: Any) {
        let strainName = nameLabel.text
        
        ref =  Database.database().reference()
        let key = strainName
        guard let userKey = Auth.auth().currentUser?.displayName
            else {
                return
        }
        
        ref?.child("Favorites").child(userKey).observeSingleEvent(of: .value, with: {snapshot in
            var count = "0"
            if let values = snapshot.value as? [String]{
                count = String(describing: values.count)
            }
            var newFavorite = [String: String]()
            newFavorite[count] = key
            self.ref?.child("Favorites").child(userKey).updateChildValues(newFavorite)
            
        })
        
        //
        
    }
    @IBAction func submitReview(_ sender: Any) {
        guard
            let reviewInput = reviewField.text
            else {
                print("Oops haha")
                return
        }
        
        print(reviewInput)
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        
        let user = Auth.auth().currentUser
        
        let strain = [
            "content" : reviewInput,
            "date" : formattedDate,
            "strain" : finalName,
            "username" : user?.email
        ]
        
        ref = Database.database().reference().child("Reviews")
        
        
        
        let key = (ref?.childByAutoId().key)!
        
        
        
       ref?.child(key).setValue(strain)
        
        reviewResults.removeAll()
    }
    
    var finalName = ""
    var finalType = ""
    var finalReviewCount = 0
    var finalEffects = [String]()
    var finalKey = ""
    
    var reviewResults = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = finalName
        typeLabel.text = finalType
        reviewCountLabel.text = "Reviews: " + String(finalReviewCount)
        
        ref = Database.database().reference().child("Reviews")
        
        databaseHandle = ref?.observe(.value, with: { snapshot in
            for child in snapshot.children {
                let childSnap = child as! DataSnapshot
                let dict = childSnap.value as! [String: Any]
                let strain = dict["strain"] as! String
                if(strain == self.finalName) {
                    let username = dict["username"] as! String
                    let date = dict["date"] as! String
                    let content = dict["content"] as! String

                    let review = Review(username: username, content: content, date: date)

                    self.reviewResults.append(review)
                    self.reviewTableView.reloadData()
                }
            }
        })
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return finalEffects.count
        if tableView == reviewTableView {
            return reviewResults.count
        }
        else {
            return finalEffects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == reviewTableView {
            let review = reviewResults[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! ReviewTableViewCell
            cell.usernameLabel.text = review.username
            cell.contentLabel.text = review.content
            cell.dateLabel.text = review.date
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StrainTableViewCell
            
            let effect = finalEffects[indexPath.row]
            cell.titleLabel.text = effect
            
            return cell
        }
    }

}
