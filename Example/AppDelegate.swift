//
//  AppDelegate.swift
//  Example
//
//  Created by James Richard on 9/29/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Cereal
import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Cereal.register(Car.self)
        Cereal.register(Train.self)
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }

        return true
    }
}

extension AppDelegate: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        var reply = [String: AnyObject]()
        defer {
            replyHandler(reply)
        }

        guard message["action"] as? String == "updateEmployees" else {
            NSLog("Not handling message \(message); unexpected action")
            return
        }

        guard let storedEmployeeData = NSUserDefaults.standardUserDefaults().objectForKey("employeeList") as? NSData else { return }
        reply["employeeList"] = storedEmployeeData
    }
    @available(iOS 9.3, *)
    @available(watchOSApplicationExtension 2.2, *)
    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
    }
    func sessionDidBecomeInactive(session: WCSession) {
    }
    func sessionDidDeactivate(session: WCSession) {
    }
}
