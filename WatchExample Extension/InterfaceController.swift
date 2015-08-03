//
//  InterfaceController.swift
//  WatchExample Extension
//
//  Created by James Richard on 9/30/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Cereal
import WatchKit
import Foundation
import WatchConnectivity

class EmployeeRowType: NSObject {
    @IBOutlet var nameLabel: WKInterfaceLabel!
}

class InterfaceController: WKInterfaceController {
    private var employees = [Employee]()

    @IBOutlet var employeesTable: WKInterfaceTable!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        configureTable()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "employeesUpdatedRemotely:", name: "EmployeeListUpdated", object: nil)
    }

    override func willActivate() {
        super.willActivate()
        refreshEmployees()
    }

    private func refreshEmployees() {
        WCSession.defaultSession().sendMessage(["action": "updateEmployees"], replyHandler: { reply in
            guard let employeeData = reply["employeeList"] as? NSData else { return }
            self.updateEmployeesWithData(employeeData)
        }, errorHandler: { error in
                NSLog("Failed to update employee list due to error: \(error)")
        })

    }

    private func configureTable() {
        employeesTable.setNumberOfRows(employees.count, withRowType: "employee")

        for (index, employee) in employees.enumerate() {
            if let row = employeesTable.rowControllerAtIndex(index) as? EmployeeRowType {
                row.nameLabel.setText(employee.name)
            }
        }
    }

    private func updateEmployeesWithData(employeeData: NSData) {
        do {
            employees = try CerealDecoder.rootCerealItemsWithData(employeeData)
            configureTable()
        } catch let error {
            NSLog("Data was unable to be decoded due to error: \(error)")
        }
    }

    @objc private func employeesUpdatedRemotely(note: NSNotification) {
        guard let employeeData = note.userInfo?["employeeList"] as? NSData else { return }
        updateEmployeesWithData(employeeData)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
