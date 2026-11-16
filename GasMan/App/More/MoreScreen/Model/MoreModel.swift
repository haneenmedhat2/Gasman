//
//  MoreModel.swift
//  Esterad
//
//  Created by Haneen on 30/10/2025.
//

import Foundation
import UIKit

enum UserMode {
    case guest
    case authenticated
    
    static var current: UserMode {
        UserDefaults.guest == true ? .guest : .authenticated
    }
}

enum MoreMenuItem : CaseIterable {
    case profile
    case settings
    case wallet
    case savedAddresses
    case termsAndConditions
    case aboutUs
    case privacyPolicy
    case contactUs
    case FAQ
    case complaints
    case myRatings
    case shareApp
    case logout
    case updateProfile
    case changephone
    case notifications
    case changePassword
    case changeLanguage
    case deleteAccount
    
    var icon : String {
        switch self {
        case .profile:
            return "profile"
        case .settings:
            return "settings"
        case .wallet:
            return "wallet"
        case .savedAddresses:
            return "location-share-02"
        case .termsAndConditions:
            return "terms"
        case .aboutUs:
            return "aboutUs"
        case .privacyPolicy:
            return "policy"
        case .contactUs:
            return "contactUs"
        case .FAQ:
            return "FQC"
        case .complaints:
            return "complaint"
        case .myRatings:
            return "rates"
        case .shareApp:
            return "share-08"
        case .logout:
            return "logout"
        case .updateProfile:
            return "settings"
        case .changephone:
            return "changePhone"
        case .notifications:
            return "fcm"
        case .changePassword:
            return "changePassword"
        case .changeLanguage:
            return "language-circle"
        case .deleteAccount:
            return "logout"
        }
    }
    
    var title : String {
        switch self {
        case .profile:
            return "profile".localized
        case .settings:
            return "settings".localized
        case .wallet:
            return "wallet".localized
        case .savedAddresses:
            return "saved_addresses".localized
        case .termsAndConditions:
            return "terms_conditions".localized
        case .aboutUs:
            return "about_app".localized
        case .privacyPolicy:
            return "privacy_policy".localized
        case .contactUs:
            return "contact_us".localized
        case .FAQ:
            return "faq".localized
        case .complaints:
            return "complaints_suggestions".localized
        case .myRatings:
            return "my_ratings".localized
        case .shareApp:
            return "share_app".localized
        case .logout:
            return "logout".localized
        case .updateProfile:
            return "edit_profile".localized
        case .changephone:
            return "change_mobile_number".localized
        case .notifications:
            return "notifications".localized
        case .changePassword:
            return "change_password".localized
        case .changeLanguage:
            return "change_language".localized
        case .deleteAccount:
            return "delete_account".localized
        }
    }
    
    var isSwitchHidden : Bool {
        switch self {
        case .profile, .settings, .wallet, .savedAddresses,.termsAndConditions ,.aboutUs, .privacyPolicy, .contactUs, .FAQ, .complaints, .myRatings , .shareApp, .logout ,.updateProfile ,.changephone, .changePassword,.changeLanguage, .deleteAccount:
            return true
        case .notifications:
            return false
        }
    }
    
    var backgroundColor : UIColor {
        switch self {
        case .profile, .settings, .wallet, .savedAddresses,.termsAndConditions ,.aboutUs, .privacyPolicy, .contactUs, .FAQ, .complaints, .myRatings , .shareApp ,.updateProfile ,.changephone, .changePassword,.changeLanguage, .notifications:
            return UIColor.moreBG
        case  .logout , .deleteAccount :
            return .clear
        }
    }
    
    var fontColor : UIColor {
        switch self {
        case .profile, .settings, .wallet, .savedAddresses,.termsAndConditions ,.aboutUs, .privacyPolicy, .contactUs, .FAQ, .complaints, .myRatings , .shareApp ,.updateProfile ,.changephone, .changePassword,.changeLanguage, .notifications:
            return .black
        case  .logout , .deleteAccount :
            return .redFont
        }
    }

    
    static func moreItems(for userType: UserMode) -> [MoreMenuItem] {
        switch userType {
        case .guest:
            return [ .settings,.termsAndConditions , .aboutUs , .privacyPolicy , .FAQ , .shareApp ]
        case .authenticated:
            return [.profile, .settings, .wallet, .savedAddresses,.termsAndConditions , .aboutUs , .privacyPolicy, .contactUs, .FAQ, .complaints,.myRatings , .shareApp ,.logout]
        }
    }
    
    static func settingsItems(for userType: UserMode) -> [MoreMenuItem] {
        switch userType {
        case .guest:
            return [.changeLanguage]
        case .authenticated:
            return [ .updateProfile ,.changephone ,.notifications , .changePassword,.changeLanguage , .deleteAccount]
        }
    }

}

