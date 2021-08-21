//
//  ViewController.swift
//  On the Map
//
//  Created by ابرار on ٢٧ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//
import UIKit
import SafariServices

class LoginViewController: UIViewController , UITextFieldDelegate {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
    }
   
    
    @IBAction func enter(_ sender: UIButton) {
        
        if email.text == "" || password.text == ""{
            showAlert( message: "Username and Password cannot be empty !")
            
        }else {
            
             activityIndicator.startAnimating()
            
            let username = email.text
            let userpassword = password.text
            let request = MainBody(udacity: objects(username: username!, password: userpassword!))
            
            loginButton.isEnabled = false
            
           ParserService.sharedInstance().authenticateuser(self, jsonBody: request) { (success,errorString) in
                DispatchQueue.main.async {
                    if success {
                        self.loginButton.isEnabled = true
                        self.activityIndicator.stopAnimating()
                        self.completeLogin()
                    }else {
                        self.loginButton.isEnabled = true
                        self.activityIndicator.stopAnimating()
                        self.showAlert(message: errorString!)
                    }
                }
                
            }
        }
    }
    
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerTabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func signupTapped(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")
        guard let newUrl = url else {return}
        let svc = SFSafariViewController(url: newUrl)
        present(svc, animated: true, completion: nil)
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


    



