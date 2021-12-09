//
//  ViewController.swift
//  Project 21
//
//  Created by 장선영 on 2021/12/09.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }


    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("yeah")
            } else {
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleLocal(timeInterval: Int) {
        registerCategories()

        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // alert 안에 보여지는 content
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        // when to show alert
        var dateComponenets = DateComponents()
        dateComponenets.hour = 10
        dateComponenets.minute = 30
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponenets, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let later = UNNotificationAction(identifier: "later", title: "Remind me later", options: .authenticationRequired)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show,later], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // user swipted th unlock
                print("Default identifier")
                let ac = UIAlertController(title: "Swipe", message: "user swipted to unlock", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            case "show":
                print("show more information")
                let ac = UIAlertController(title: "Show", message: "show more information", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            case "later":
                // alert after a day
               scheduleLocal(timeInterval: 86400)
                
            default:
                break
            }
            
            // challenge 1
           
            
        }
        
        completionHandler()
    }
}

