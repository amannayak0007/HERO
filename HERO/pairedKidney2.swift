//
//  pairedKidney2.swift
//  HERO
//
//  Created by amrun on 24/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import MessageUI

class pairedKidney2: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var connect: UIButton!
    @IBOutlet weak var invite: UIButton!
    
    let alertView: FCAlertView = {
        let alert = FCAlertView(type: .warning)
        alert.dismissOnOutsideTouch = true
        
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Paired Kidney Exchange"
        self.extendedLayoutIncludesOpaqueBars = true
    }

    @IBAction func connectPressed(_ sender: Any) {
        connect.setImage(#imageLiteral(resourceName: "connectblue"), for:. normal)
        invite.setImage(#imageLiteral(resourceName: "invitegray"), for:. normal)
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            SVProgressHUD.dismiss()
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "pairedKidney3") as! pairedKidney3
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func invitePressed(_ sender: Any) {
        connect.setImage(#imageLiteral(resourceName: "connectgray"), for:. normal)
        invite.setImage(#imageLiteral(resourceName: "inviteblue"), for:. normal)
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hello! \(donorModel.fullName!) invited you to join Hero. Bit.ly/HeroApp #HERO"
            controller.recipients = []
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case MessageComposeResult.cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
            
        case MessageComposeResult.failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                SVProgressHUD.showError(withStatus: "Invitation Sending Failed")
            }
        case MessageComposeResult.sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)

            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                SVProgressHUD.showSuccess(withStatus: "Invitation Sent")
            }
        default:
            break
        }
        
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        if(connect.image(for: .selected) == #imageLiteral(resourceName: "connectblue") || invite.image(for: .selected) == #imageLiteral(resourceName: "inviteblue")){
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                SVProgressHUD.dismiss()
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabbarVC") as! tabbarVC
                vc.modalPresentationStyle = .custom
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                SVProgressHUD.dismiss()
                self.alertView.showAlert(inView: self,
                                         withTitle: "Select Option",
                                         withSubtitle:"Please select any one option.",
                                         withCustomImage: UIImage(named:"herologo"),
                                         withDoneButtonTitle:"Dismiss",
                                         andButtons:nil)
            }
        }
    }
    
      @IBAction func unwindTokidneyview(segue: UIStoryboardSegue) {}
    
}
