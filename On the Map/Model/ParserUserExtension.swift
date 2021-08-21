//
//  OTMParseClientl.swift
//  On the Map
//
//  Created by ابرار on ٢٧ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - OTMParseClient (Convenient Resource Methods)

extension ParserUser  {
    
    
    func getAllDataFormUsers(_ completionHandlerForUserID: @escaping (_ success: Bool,_ usersData: [Any]?, _ errorString: String?) -> Void) {
        
        let parameters =  [ParserUser .ParameterKeys.Limit:ParserUser.ParameterValues.Limit,ParserUser .ParameterKeys.Order:ParserUser.ParameterValues.Order]
        
        /* 2. Make the request */
        
        _ = taskForGETMethod(ParserUser.Methods.StudentLocation, parameters: parameters as [String : AnyObject] , decode: StudentLocations.self) { (result, error) in
            
            
            if let error = error {
                
                completionHandlerForUserID(false ,nil ,"\(error.localizedDescription)")
            }else {
                let newResult = result as! StudentLocations
                if let usersData = newResult.results  {
                    completionHandlerForUserID(true ,usersData,nil)
                    
                }else {
                    completionHandlerForUserID(false ,nil ,"\( error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    
    func getuserDataByUniqueKey(_ completionHandlerForUserID: @escaping (_ success: Bool,_ objectId:String?, _ errorString: String?) -> Void) {
        
        
        let method: String = Methods.StudentLocation
        
        let newParameterValues = substituteKeyInMethod(ParserUser.ParameterValues.Where, key: ParserUser.requestKeys.UserID, value: ParserService.sharedInstance().userID!)!
        
        
        let parameters =  [ParserUser.ParameterKeys.Where:newParameterValues]
        
        
        /* 2. Make the request */
        
        
        _ = taskForGETMethod(method, parameters: parameters as [String : AnyObject], decode: StudentLocations.self) { (result, error) in
            
            
            if let error = error {
                
                completionHandlerForUserID(false ,nil ,"\(error.localizedDescription)")
            }else {
                let newResult = result as! StudentLocations
                
                if !((newResult.results?.isEmpty)!){
                    if let usersData = newResult.results  {
                        
                        // if there is data (user already posted his Location)
                        // get objectId
                        if let objectId = usersData[0].objectId    {
                           ParserUser.sharedInstance().objectId = objectId
                            
                            
                        }
                        
                        completionHandlerForUserID(true ,self.objectId,nil)
                    }else {
                        completionHandlerForUserID(false ,nil ,"\( error!.localizedDescription)")
                        
                    }
                    
                }else {
                    completionHandlerForUserID(true ,self.objectId ,nil)
                    
                }
                
                
            }
        }
        
    }
    
    func postUserLocation<E: Encodable>( jsonBody:E ,completionHandlerForSession: @escaping (_ success: Bool , _ errorString: String?) -> Void) {
        
        
        _ = taskForPOSTMethod(Methods.StudentLocation, decode: StudentLocationsResponse.self, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,"\(error.localizedDescription) ")
            }else {
                if result != nil{
                    completionHandlerForSession(true ,nil)
                    
                }else {
                    completionHandlerForSession(false ," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    func putUserLocation<E: Encodable>( jsonBody:E ,completionHandlerForSession: @escaping (_ success: Bool , _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        
        
        /* 2. Make the request */
        
        var mutableMethod: String = Methods.StudentLocationUpdate
        mutableMethod = substituteKeyInMethod(mutableMethod, key:  requestKeys.ObjectId, value: String(self.objectId!))!
        
        _ = taskForPUTMethod(mutableMethod, decode: StudentLocationsUpdateResponse.self, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,"\(error.localizedDescription) ")
            }else {
                if result != nil {
                    completionHandlerForSession(true  ,nil)
                    
                }else {
                    completionHandlerForSession(false ," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    
    
}


