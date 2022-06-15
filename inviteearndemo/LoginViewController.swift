//
//  LoginViewController.swift
//  inviteearndemo
//
//  Created by Michael Hathi on 08/06/22.
//

import UIKit
import FlyyFramework
import FirebaseMessaging

class LoginViewController: UIViewController {
    @IBOutlet weak var referralCodeTF: UITextField!
    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sign Up"
    }
    
    @IBAction func setReferralCode(_ sender: Any) {
        let referralCode = referralCodeTF.text ?? ""
        if (referralCode.isEmpty) {
            showAlert("Referral Code", "Invalid Referral Code")
        } else {
            Flyy.sharedInstance.verifyReferralCode(referralCode: referralCode, onComplete: { (success, referralCode) -> Void in
                if(success) {
                    Flyy.sharedInstance.setReferralCode(referralCode: referralCode)
                    DispatchQueue.main.async {
                        self.showAlert("Referral Code", "Success: Referral code applied")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("Referral Code", "Invalid Referral Code")
                    }
                }
            })
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        let userId = userIdTF.text ?? ""
        let userName = userNameTF.text ?? ""
        
        if (userId.isEmpty) {
            showAlert("User Id", "User Id is required")
        } else {
            Flyy.sharedInstance.setNewUser(externalUserId: userId)
            var fcmToken = ""
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching FCM registration token: \(error)")
                } else if let token = token {
                    print("FCM registration token: \(token)")
                    fcmToken  = token
                    Flyy.sharedInstance.sendFcmTokenToServer(fcmToken: fcmToken)
                }
            }
        }
        
        if (!userName.isEmpty) {
            Flyy.sharedInstance.setUserName(userName: userName)
        }
        
        navigateToHome()
    }
    @IBAction func resetSDK(_ sender: Any) {
        //Clear User Defaults
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToHome() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
