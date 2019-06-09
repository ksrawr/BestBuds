//
//  SearchStrainViewController.swift
//  BestBuds
//
//  Created by Khoi Dao on 5/12/19.
//  Copyright © 2019 An Dao & Kenneth Surban. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchStrainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func backAction(_ sender: Any) {
        performSegue(withIdentifier: "SearchToHome", sender: self)
        
        //prepare(for: <#T##UIStoryboardSegue#>, sender: <#T##Any?#>)
        //let vc = HomeViewController()
        //present(vc, animated: true, completion: nil)
        
        
        //self.performSegue(withIdentifier: "BackToHome", sender: self)
       
    }
    @IBAction func searchButton(_ sender: Any) {
        guard
            let searchInput = searchField.text
            else {
                print("Something helpful")
                return
        }
        strainData.removeAll()
        
        for strain in cpyData {
            if(strain.name.contains(searchInput.lowercased()) || strain.type.contains(searchInput.lowercased())){
                strainData.append(strain)
                self.tableView.reloadData()
            }
        }
    }
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    var strainData = [Strain]()
    var cpyData = [Strain]()
    
    var strainText = ""
    var strainType = ""
    var strainReviewCount = 0
    var strainEffects = [String]()
    var strainKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference().child("Strains")
        
        //        strainData.append(Strain(name: "test",type: "indica",effects: ["happy"], reviews: []))
        
        databaseHandle = ref?.observe(.value, with: { snapshot in
            for child in snapshot.children {
                let stringChild = self.ref!.childByAutoId().key as! String
                
                let childSnap = child as! DataSnapshot
                let dict = childSnap.value as! [String: Any]
                let name = dict["name"] as! String
                let type = dict["type"] as! String
                let effects = dict["effects"] as! [String]
                let reviews = 0
                
                let strain = Strain(name: name, type: type, effects: effects, reviews: reviews, childKey: stringChild)
                self.strainData.append(strain)
                self.cpyData.append(strain)
                
                self.tableView.reloadData()
            }
        })
        
        ref = Database.database().reference().child("Reviews")
        
        databaseHandle = ref?.observe(.value, with: {snapshot in
            for child in snapshot.children {
                let childSnap = child as! DataSnapshot
                let dict = childSnap.value as! [String: Any]
                let strain = dict["strain"] as! String
                for strainObj in self.strainData {
                    if(strain == strainObj.name) {
                        strainObj.reviews = strainObj.reviews + 1;
                    }
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
        return strainData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let strain = strainData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.titleLabel.text = (strain.name + " type:" + strain.type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strain = strainData[indexPath.row]

        self.strainText = strain.name
        self.strainType = strain.type
        self.strainReviewCount = strain.reviews
        self.strainEffects = strain.effects
        self.strainKey = strain.childKey

        performSegue(withIdentifier: "strainNav", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "strainNav") {
        
        let vc = segue.destination as! StrainViewController
        vc.finalName = self.strainText
        vc.finalType = self.strainType
        vc.finalReviewCount = self.strainReviewCount
        vc.finalEffects = self.strainEffects
        vc.finalKey = self.strainKey
    }
        else if (segue.identifier == "SearchToHome"){
            let vc = segue.destination as! HomeViewController
        }
    
}
}
