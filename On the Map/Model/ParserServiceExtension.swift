//
//  vv.swift
//  On the Map
//
//  Created by ابرار on ٢٧ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - OTMParseClient (Convenient Resource Methods)

extension ParserService {
    
    
    func authenticateuser<E: Encodable>(_ hostViewController: UIViewController,jsonBody: E, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        
        
        
        self.getaccuntSession(jsonBody: jsonBody) { (success, sessionID,userID, errorString) in
            
            if success {
                
                // success! we have the sessionID!
                self.sessionID = sessionID
                self.userID = userID
                
                
                self.getPublicData(userID: userID) { (success, nickname, errorString) in
                    
                    if success {
                        print("nickname is: \(nickname)")
                        
                        if let nickname = nickname {
                            self.nickname = "\(nickname)"
                        }
                        
                        
                    }
                    
                    completionHandlerForAuth(success, errorString)
                }
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
        
        
        
        
    }
    
    
    
    
    private func getaccuntSession<E: Encodable>( jsonBody:E ,completionHandlerForSession: @escaping (_ success: Bool , _ sessionID: String?,_ userID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        
        
        /* 2. Make the request */
        
        _ = taskForPOSTMethod(functions.AuthenticationSession, decode: ServiceResponse.self, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,nil ,nil,"\(error.localizedDescription) ")
            }else {
                let newResult = result as! ServiceResponse
                if let sessionID = newResult.session.id , let userID = newResult.account.key  {
                    completionHandlerForSession(true ,sessionID,userID ,nil)
                    
                }else {
                    completionHandlerForSession(false ,nil ,nil," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    func deleteSession(_ completionHandlerForSession: @escaping (_ success: Bool , _ sessionID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        
        
        /* 2. Make the request */
        
        
        
        _ = taskForDeleteMethod(functions.AuthenticationSession, decode:  DeletetheSession.self, completionHandlerForDelete: { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,nil,"\(error.localizedDescription) ")
            }else {
                let newResult = result as!  DeletetheSession
                if let sessionID = newResult.session.id  {
                    completionHandlerForSession(true ,sessionID ,nil)
                    
                }else {
                    completionHandlerForSession(false ,nil ," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        )
    }
    
    private func getPublicData(userID: String?,_ completionHandlerForUserID: @escaping (_ success: Bool,_ nickname: String?, _ errorString: String?) -> Void) {
        
        
        
        
        
        var mutableMethod: String = functions.AuthenticationGetPublicDataForUserID
        mutableMethod = substituteKeyInMethod(mutableMethod, key: ParserService.URLKeys.UserID, value: String(ParserService.sharedInstance().userID!))!
        
        
        
        /* 2. Make the request */
        
        _ = taskForGETMethod(mutableMethod , decode: UserData.self) { (result, error) in
            
            
            if let error = error {
                
                completionHandlerForUserID(false ,nil ,"\(error.localizedDescription)")
            }else {
                let newResult = result as! UserData
                if let nickname = newResult.nickname  {
                    
                    completionHandlerForUserID(true ,nickname,nil)
                    
                }else {
                    completionHandlerForUserID(false ,nil,"\(String(describing: error?.localizedDescription))")
                    
                }
                
                
            }
        }
        
    }
    
}


