//
//  Session.swift
//  Esterad
//
//  Created by Haneen on 13/01/2026.
//
import Foundation

struct Session {
    static var token: String? {
        get {
            return UserDefaults.accessToken
        }
        set {
            UserDefaults.accessToken = newValue
        }
    }
    
    static var isLogin: Bool? {
        get {
            return UserDefaults.isLogin
        }
        set {
            UserDefaults.isLogin = newValue ?? true
        }
    }
    
    static var user: User? {
        get {
            return UserDefaults.user
        }
        set {
            UserDefaults.user = newValue
        }
    }
    
    static var isGuest: Bool? {
        get {
            return UserDefaults.guest
        }
        set {
            UserDefaults.guest = newValue ?? true 
        }
    }

}
