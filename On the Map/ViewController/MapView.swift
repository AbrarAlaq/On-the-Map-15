//
//  MapView.swift
//  On the Map
//
//  Created by ابرار on ٢٧ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SafariServices

class MapView: UIViewController , MKMapViewDelegate{
     var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var mapView: MKMapView!
    
    private var annotations = [MKPointAnnotation]()
    
    var usersData = SharedArray.shared.InfoArray
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllUsersData()
    }
    
    
    func getAllUsersData(){
        
        self.usersData.removeAll()
        annotations.removeAll()
        let AnnotationsArray = self.mapView.annotations
        self.mapView.removeAnnotations(AnnotationsArray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        ParserUser.sharedInstance().getAllDataFormUsers { (success, usersData, errorString) in
            
            if success {
                
                self.usersData = usersData as! [objectre]
                
                self.UsersDataArrang(UsersData: self.usersData as! [objectre])
                
                self.stopActivityIdecator()
            }else {
                self.stopActivityIdecator()
                self.showAlert( message: errorString!)
            }
        }
        
    }
    
    
    
    func stopActivityIdecator(){
        DispatchQueue.main.async {
           self.activityIndicator.stopAnimating()
        }
    }
    
    func UsersDataArrang(UsersData:[objectre]){
        
        
        for i in UsersData{
            
            
            if let data = i.latitude, let longitude = i.longitude , let first = i.firstName ,let last = i.lastName , let mediaURL = i.mediaURL {
                
                let short = CLLocationDegrees(data)
                let long = CLLocationDegrees(longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: short, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                self.annotations.append(annotation)
                
                
                
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                self.activityIndicator.stopAnimating()
                
                
            }
            
            
        }
        
    }
    
    
    
    @IBAction func refreshNewData(_ sender: Any) {
        
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
    
    
    @IBAction func AddLocation(_ sender: Any) {
        
        ParserUser.sharedInstance().getuserDataByUniqueKey { (success, objectID, errorString) in
            
            if success {
                
                // if the usersData is not equal nil : that mean the user did already post Location to parse ( get objectId and Ask if he want to update !)
                // but if the usersData is equal nil : that mean the user never post his Location ! (let him post !)
                if objectID == nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toAddLocation", sender: nil)
                        
                    }
                }else {
                    //ask user if his want to overwriting!
                    //                    Alert.showAlertWithTwoButtons(on: self, with: "User \(OTMParseClient.sharedInstance().userFullName!) Has Already Posted a Stdent Location. Whould you Like to Overwrite Thier Location?")
                    
                    self.showAlertWithTwoButtons(with: "User \(ParserService.sharedInstance().nickname!) is entred.Are you Like to Overwrite This Location?", completionHandlerForAlert: { (action) in
                        
                        self.performSegue(withIdentifier: "toAddLocation", sender: nil)
                        
                    })
                    
                }
                
                
            }else {
                self.showAlert( message: errorString!)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let Id = "pin"
        
        var Pin = mapView.dequeueReusableAnnotationView(withIdentifier: Id) as? MKPinAnnotationView
        
        if Pin == nil {
            Pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Id)
            Pin!.canShowCallout = true
            Pin!.pinTintColor = .red
            Pin!.rightCalloutAccessoryView = UIButton(type: .infoDark)
        }
        else {
            Pin!.annotation = annotation
        }
        
        
        return Pin
    }
    
    
    
    func URLSafari(url:URL){
        
        if url.absoluteString.contains("http"){
            let Safariweb = SFSafariViewController(url: url)
            present(Safariweb, animated: true, completion: nil)
        }else {
            DispatchQueue.main.async {
                self.showAlert( message: "URL is not found !")
            }
        }
        
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            if let browser = view.annotation?.subtitle! {
                guard let url = URL(string: browser) else {return}
                URLSafari(url:url)
                
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotation: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotation.rightCalloutAccessoryView {
            guard let Url = annotation.annotation?.subtitle else {return}
            guard let BeforeUrl = Url else {return}
            guard let url = URL(string: BeforeUrl) else {return}
            URLSafari(url:url)
            
        }
    }
    func showAlertWithTwoButtons( with message: String , completionHandlerForAlert: @escaping ( _ action: UIAlertAction?) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: completionHandlerForAlert))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        DispatchQueue.main.async { self.present(alert, animated: true) }
    }
    func showAlert( message: String) {
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
            
        }
    }
}



