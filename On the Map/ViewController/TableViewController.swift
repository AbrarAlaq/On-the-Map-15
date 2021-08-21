//
//  TableViewController.swift
//  On the Map
//
//  Created by ابرار on ٢٧ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation

import UIKit
import SafariServices

class TableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var usersDataTableview: UITableView!
    
    var usersDataArray = SharedArray.shared.InfoArray
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        getAllUsersData()
    }
    
    
    func getAllUsersData(){
        usersDataArray.removeAll()
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        ParserUser.sharedInstance().getAllDataFormUsers { (success, usersData, errorString) in
            
            
            if success {
                
                guard let newUsersData = usersData else {return}
                
                self.usersDataArray = newUsersData as! [objectre]
                
                DispatchQueue.main.async {
                     self.activityIndicator.stopAnimating()
                    
                    self.usersDataTableview.reloadData()
                }
                
            }else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.showAlert( message: errorString!)
                
                
            }
            
        }
        
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        ParserUser.sharedInstance().getuserDataByUniqueKey { (success, usersData, errorString) in
            
            if success {
                
                // if the usersData is not equal nil : that mean the user did already post Location to parse ( get objectId and Ask if he want to update !)
                // but if the usersData is equal nil : that mean the user never post his Location ! (let him post !)
                if usersData != nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toAddLocation", sender: nil)
                        
                    }
                }else {
                    //ask user if his want to overwriting!
                    //                    Alert.showAlertWithTwoButtons(on: self, with: "User \(OTMParseClient.sharedInstance().userFullName!) Has Already Posted a Stdent Location. Whould you Like to Overwrite Thier Location?")
                    
                    self.showAlertWithTwoButtons( with: "User \(ParserService.sharedInstance().nickname!) Has Already Posted a Stdent Location. Whould you Like to Overwrite Thier Location?", completionHandlerForAlert: { (action) in
                        
                        self.performSegue(withIdentifier: "toAddLocation", sender: nil)
                        
                    })
                    
                }
                
                
            }else {
                self.showAlert( message: errorString!)
            }
        }
        
        
        
    }
    
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        getAllUsersData()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        ParserService.sharedInstance().deleteSession { (success, sessionID, errorString) in
            
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                    
                }else {
                    self.showAlert( message: errorString!)
                }
            }
            
        }
        
    }
    func showAlert( message: String) {
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
            
        }
    }
    func showAlertWithTwoButtons( with message: String , completionHandlerForAlert: @escaping ( _ action: UIAlertAction?) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: completionHandlerForAlert))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        DispatchQueue.main.async { self.present(alert, animated: true) }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataArray = usersDataArray as! [objectre]
        
        if let urlString = dataArray[indexPath.row].mediaURL,
            let url = URL(string: urlString){
            
            if url.absoluteString.contains("http://"){
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            }else {
                
                DispatchQueue.main.async {
                    self.showAlert(message: "Cannot Open , Because it's Not Vailed Website !!")
                }            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersDataCell") as! CellTableView
        
        
        cell.Datacontent(usersData: usersDataArray[indexPath.row] as! objectre)
        
        return cell
        
    }
}




