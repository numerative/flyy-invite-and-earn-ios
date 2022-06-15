//
//  ViewController.swift
//  inviteearndemo
//
//  Created by Michael Hathi on 18/05/22.
//

import UIKit
import FlyyFramework
import FirebaseMessaging

class ViewController: UIViewController {
    
    @IBOutlet weak var packageNameTF: UITextField!
    @IBOutlet weak var partnerIDTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SDK Setup"
        
        prefill()
        
    }
    
    /// Navigate to the next screen.
    @IBAction func navigateToNext(_ sender: Any) {
        let packageName = packageNameTF.text ?? ""
        let partnerId = partnerIDTF.text ?? ""
        let preferences = UserDefaults.standard
        
        if (packageName.isEmpty || partnerId.isEmpty)
        {
            showAlert()
        } else {
            preferences.set(packageName, forKey: "package_name")
            preferences.set(partnerId, forKey: "partner_id")
            
            initializeSDK(packageName: packageName, partnerId: partnerId)
            navigateToLogin()
        }
        
        
    }
    
    func initializeSDK(packageName: String, partnerId: String) {
        
        Flyy.sharedInstance.initSDK(partnerToken: partnerId, environment: Flyy.FLYY_ENVIRONMENT_STAGING,
                                    onComplete: { (success, referralCode) -> Void in
            if(success) {
                print(referralCode)
                DispatchQueue.main.async {
                    self.showAlert("Referral Code", referralCode + " applied")
                }
            } else {
                print(referralCode)
                DispatchQueue.main.async {
                    self.showAlert("Referral Code", referralCode + " invalid")

                }
            }
        })
        Flyy.sharedInstance.setPackage(packageName: packageName)
    }
    
    /// Prefill Pacakage Name and Partner Id if stored values are found.
    func prefill() {
        let preferences = UserDefaults.standard
        
        let packageName = preferences.string(forKey: "package_name") ?? ""
        let partnerId = preferences.string(forKey: "partner_id") ?? ""
        
        if (!packageName.isEmpty && !partnerId.isEmpty) {
            packageNameTF.text = packageName
            partnerIDTF.text = partnerId
        }
    }
    
    func navigateToLogin() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Text field Empty", message: "Package Name and Partner ID are required", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}

