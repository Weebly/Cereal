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

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Cereal.register(Car.self)
        Cereal.register(Train.self)
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }

        return true
    }
}

extension AppDelegate: WCSessionDelegate {

    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) { }

    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) { }

    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var reply = [String: AnyObject]()
        defer {
            replyHandler(reply)
        }

        guard message["action"] as? String == "updateEmployees" else {
            NSLog("Not handling message \(message); unexpected action")
            return
        }

        guard let storedEmployeeData = UserDefaults.standard.object(forKey: "employeeList") as? Data else { return }
        reply["employeeList"] = storedEmployeeData as AnyObject?
    }
}
