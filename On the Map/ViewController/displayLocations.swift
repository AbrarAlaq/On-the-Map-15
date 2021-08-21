//
//  displayLocations.swift
//  On the Map
//
//  Created by ابرار on ٣٠ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class displayLocations: UIViewController {
     var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var mapView: MKMapView!
    
    var mapString:String?
    var mediaURL:String?
    var latitude:Double?
    var longitude:Double?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        createAnnotation()
        
    }
    
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        // if objectId == nil , it's mean this is the frist time the user post !
        if ParserUser.sharedInstance().objectId == nil {
            postNewStudentLocation()
        }else {
            // if objectId != nil , that mean the user will updating his post !
            updateStudentLocation()
            
        }
    }
    
    func postNewStudentLocation(){
        
        if let nickname = ParserService.sharedInstance().nickname {
            var components = nickname.components(separatedBy: " ")
            if(components.count > 0)
            {
                let firstName = components.removeFirst()
                let lastName = components.joined(separator: " ")
                
                
                let jsonBody = StudentLocationsBody(uniqueKey:ParserService.sharedInstance().userID! , firstName:firstName, lastName:lastName ,mapString:mapString!,mediaURL:mediaURL! ,latitude:latitude! , longitude:longitude!)
                
                
                ParserUser.sharedInstance().postUserLocation(jsonBody: jsonBody) { (success, errorString) in
                    
                    if success {
                        print(success)
                        
                        self.returnBackToRoot()
                        
                    }else {
                        self.showAlert( message: errorString!.localizedCapitalized)
                    }
                    
                }
            }
            
        }
        
        
    }
    
    func updateStudentLocation(){
        
        if let fullName = ParserService.sharedInstance().nickname {
            var components = fullName.components(separatedBy: " ")
            if(components.count > 0)
            {
                let firstName = components.removeFirst()
                let lastName = components.joined(separator: " ")
                
                
                let jsonBody = StudentLocationsBody(uniqueKey:ParserService.sharedInstance().userID! , firstName:firstName, lastName:lastName ,mapString:mapString!,mediaURL:mediaURL! ,latitude:latitude! , longitude:longitude!)
                
                
                ParserUser.sharedInstance().putUserLocation(jsonBody: jsonBody) { (success, errorString) in
                    
                    if success {
                        print(success)
                        
                        self.returnBackToRoot()
                    }else {
                        self.showAlert( message: errorString!.localizedCapitalized)
                    }
                    
                }
            }
            
        }
        
        
    }
    
    func returnBackToRoot() {
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.isHidden = false
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
        
    }
    
    func createAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.title = mapString!
        annotation.subtitle = mediaURL!
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        self.mapView.addAnnotation(annotation)
        
        
        //zooming to location
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    func showAlert( message: String) {
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
            
        }
    }
    
}
