//
//  HomeViewController.swift
//  BestBuds
//
//  Created by An Dao on 4/29/19.
//  Copyright © 2019 An Dao & Kenneth Surban. All rights reserved.
//

import UIKit
import Firebase 

class HomeViewController: UIViewController {

    @IBAction func loadDash(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToDashBoard", sender: self)
    }
    @IBAction func loadSearch(_ sender: Any) {
        self.performSegue(withIdentifier: "searchScreen", sender: sender)
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
