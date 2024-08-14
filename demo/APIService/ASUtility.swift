//
//  ASUtility.swift
//  Feemium
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

class ASUtility: NSObject {
    
    static let shared = ASUtility()
    
    /// This function is used to show an alert popup for confirmation of user.
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Brief message for the alert
    ///   - lblDone: Lable string for the done button
    ///   - lblCancel: lable string for the cancel button
    ///   - controller: controller from where this alert is called
    ///   - completion: return the result.
    func showConfirmAlert(with title: String, message: String, lblDone: String, lblCancel: String, on controller: UIViewController? = nil, completion: @escaping (_ choice: Bool) -> Void) {
        
        let objAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        objAlert.addAction(UIAlertAction(title: lblDone, style: .default, handler: { (_) in
            completion(true)
            return
        }))
        
        objAlert.addAction(UIAlertAction(title: lblCancel, style: .cancel, handler: { (_) in
            completion(false)
            return
        }))
        
        kMainQueue.async {
            if controller != nil {
                controller!.present(objAlert, animated: true, completion: nil)
                return
            }
            kAppDelegate.window?.rootViewController?.present(objAlert, animated: true, completion: nil)
        }
    }
    
    /// This function is used to show a dismiss alert popup for user.
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Brief message for the alert
    ///   - lblDone: Lable string for the done button
    ///   - controller: controller from where this alert is called
    func dissmissAlert(title: String, message: String, lblDone: String, on controller: UIViewController? = nil) {
        let objAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        objAlert.addAction(UIAlertAction(title: lblDone, style: .default, handler: { (_) in
        }))
        
        kMainQueue.async {
            if controller != nil {
                controller!.present(objAlert, animated: true, completion: nil)
                return
            }
            kAppDelegate.window?.rootViewController?.present(objAlert, animated: true, completion: nil)
        }
    }
    
    /// This function is used to show a toast alert.
    ///
    /// - Parameters:
    ///   - msg: message to be shown on toast
    ///   - controller: controller from where this alert is called
    func showToast(with msg: String, on controller: UIViewController? = nil) {
        let toast = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(2)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            toast.dismiss(animated: true, completion: nil)
        }
        kMainQueue.async {
            if controller != nil {
                controller!.present(toast, animated: true, completion: nil)
                return
            }
            kAppDelegate.window?.rootViewController?.present(toast, animated: true, completion: nil)
        }
    }
    
    //MARK:- ------ Get device Info ------
    
    /// This function is used to get the device related information i.e device type, os version, device id.
    ///
    /// - Returns: returns device type, os version, device id.
    func getDeviceInfo() -> [String: String] {
        
        let strModel = UIDevice.current.model //// e.g. @"iPhone", @"iPod touch"
        let strVersion = UIDevice.current.systemVersion // e.g. @"4.0"
        let strDevID = UIDevice.current.identifierForVendor?.uuidString
        
        let tempDict: [String: String] = [
            "device_type": strModel,
            "os_version": strVersion,
            "device_id": strDevID ?? ""
        ]
        return tempDict
    }
    
    //Email Valid
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    
    func isValidMobile(testStr:String) -> Bool {
        let mobileRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        return mobileTest.evaluate(with: testStr)
    }
    // "^[7-9][0-9]{9}$"
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func logOutMethod()
    {
         UserDefaults.standard.set(nil, forKey: "IsAutoLoginEnable")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //let userData:NSDictionary = [:]
        //print(userData)
        //UserDefaults.standard.set(userData, forKey: "info")
        //
       // LoginVC ViewController
        var initialViewController = UIViewController()
        initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        let nav = UINavigationController(rootViewController: initialViewController)
        nav.navigationBar.isHidden = true
        nav.interactivePopGestureRecognizer?.isEnabled = false
        UIApplication.shared.keyWindow?.rootViewController = nav
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        
    }

    
    //user default
    
     func writeStringUserPreference(_ key: String?, value: Any?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key ?? "")
        userDefaults.synchronize()
     }
    
    // ** Read
    
      func readStringUserPreference(_ key: String?) -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: key!) as? String
     }
    
}
