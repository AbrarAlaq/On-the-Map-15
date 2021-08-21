//
//  OTMUdacityConstants.swift
//  On the Map
//
//  Created by ابرار on ٢٧ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation

// MARK: - OTMUdacityConstants (Constants)

extension ParserService {
    
    // MARK: Constants
    struct Constants {
        
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "onthemap-api.udacity.com"
        static let ApiPath = "/v1"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Methods
    struct functions {
        
        
        // MARK: Authentication
        static let AuthenticationSession = "/session"
        static let AuthenticationGetPublicDataForUserID = "/users/{id}"
        
        
        
    }
    
    
    
    
}
