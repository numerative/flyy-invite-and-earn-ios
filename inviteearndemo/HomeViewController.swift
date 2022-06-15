//
//  HomeViewController.swift
//  inviteearndemo
//
//  Created by Michael Hathi on 08/06/22.
//

import UIKit
import FlyyFramework

class HomeViewController: UIViewController {

    @IBOutlet weak var eventKeyTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        prefillEventKey()
    }
    
    @IBAction func sendEventBtn(_ sender: Any) {
        let eventKey = eventKeyTF.text ?? ""
        if (!eventKey.isEmpty) {
            Flyy.sharedInstance.sendEventWithJson(key: eventKey, value: "true")
        }
        
    }
    
    @IBAction func openOffers(_ sender: Any) {
        Flyy.sharedInstance.openOffersPage()
    }
    
    @IBAction func referralHistory(_ sender: Any) {
        Flyy.sharedInstance.openReferralHistoryPage()
    }
    @IBAction func referralCount(_ sender: Any) {
        Flyy.sharedInstance.getReferralCount(onComplete: {(success, referralCount) -> Void in
            if(success) {
                DispatchQueue.main.async {
                    self.showAlert("Referral Count", String(referralCount))
                }
            }
        })
    }
    
    func prefillEventKey() {
        let preferences = UserDefaults.standard
        let eventKey = preferences.string(forKey: "event_key") ?? "kyc_done"
        eventKeyTF.text = eventKey
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}
