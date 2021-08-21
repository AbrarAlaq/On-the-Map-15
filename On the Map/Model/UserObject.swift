//
//  Objects.swift
//  On the Map
//
//  Created by ابرار on ٢٧ جما١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//
import Foundation

//Mark: Udacity session JSON Body
struct  MainBody : Codable {
    let udacity : objects
}

struct objects : Codable {
    let username:String
    let password:String
}

//Mark: Udacity session JSON Response
struct ServiceResponse : Codable {
    let account : UserAccount
    let session : Session
    
}

struct UserAccount : Codable {
    let registered : Bool?
    let key : String?
}

struct DeletetheSession : Codable {
    let session : Session
}

struct Session : Codable {
    let id : String?
    let expiration : String?
}

//Mark: User Data (Frist and Last Name)

struct UserData : Codable {
    let nickname : String?
    
}





