//
//  AddnewLocationViewController.swift
//  On the Map
//
//  Created by ابرار on ٢٧ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddnewLocationViewController: UIViewController , UITextFieldDelegate{
     var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var yourLocationTextfield: UITextField!
    
    @IBOutlet weak var yourWebsiteTextfield: UITextField!
    
    var latitude : Double?
    var longitude : Double?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func returnBackToRoot() {
        DispatchQueue.main.async {
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        returnBackToRoot()
        
    }
    
    
    @IBAction func findLocation(_ sender: UIButton) {
        
        guard let websiteLink = yourWebsiteTextfield.text else {return}
        
        if websiteLink.range(of:"http://") == nil{
            self.showAlert( message: "The Website Should Contains http://")
        }else {
            if yourLocationTextfield.text != "" && yourWebsiteTextfield.text != "" {
                
                activityIndicator.center = view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = .gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = yourLocationTextfield.text
                
                let activeSearch = MKLocalSearch(request: searchRequest)
                
                activeSearch.start { (response, error) in
                    
                    if error != nil {
                        self.activityIndicator.stopAnimating()
                        
                        print("Location Error : \(error!.localizedDescription)")
                        self.showAlert( message: "Location Not Found")
                    }else {
                        self.activityIndicator.stopAnimating()
                        
                        self.latitude = response?.boundingRegion.center.latitude
                        self.longitude = response?.boundingRegion.center.longitude
                        
                        self.performSegue(withIdentifier: "toFinalAddLocation", sender: nil)
                    }
                }
            }else {
                DispatchQueue.main.async {
                    
                    self.showAlert( message: "You need to enter your Location & your URL ! ")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFinalAddLocation"{
            let vc = segue.destination as!  displayLocations
            
            vc.mapString = yourLocationTextfield.text
            vc.mediaURL = yourWebsiteTextfield.text
            vc.latitude = self.latitude
            vc.longitude = self.longitude
            
        }
        
    }
    
    func showAlert( message: String) {
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

