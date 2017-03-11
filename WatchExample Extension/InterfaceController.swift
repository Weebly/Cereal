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
    fileprivate var employees = [Employee]()

    @IBOutlet var employeesTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        configureTable()
        NotificationCenter.default.addObserver(self, selector: #selector(InterfaceController.employeesUpdatedRemotely(_:)), name: NSNotification.Name(rawValue: "EmployeeListUpdated"), object: nil)
    }

    override func willActivate() {
        super.willActivate()
        refreshEmployees()
    }

    fileprivate func refreshEmployees() {
        WCSession.default().sendMessage(["action": "updateEmployees"], replyHandler: { reply in
            guard let employeeData = reply["employeeList"] as? Data else { return }
            self.updateEmployeesWithData(employeeData)
        }, errorHandler: { error in
                NSLog("Failed to update employee list due to error: \(error)")
        })

    }

    fileprivate func configureTable() {
        employeesTable.setNumberOfRows(employees.count, withRowType: "employee")

        for (index, employee) in employees.enumerated() {
            if let row = employeesTable.rowController(at: index) as? EmployeeRowType {
                row.nameLabel.setText(employee.name)
            }
        }
    }

    fileprivate func updateEmployeesWithData(_ employeeData: Data) {
        do {
            employees = try CerealDecoder.rootCerealItemsWithData(data: employeeData)
            configureTable()
        } catch let error {
            NSLog("Data was unable to be decoded due to error: \(error)")
        }
    }

    @objc fileprivate func employeesUpdatedRemotely(_ note: Notification) {
        guard let employeeData = note.userInfo?["employeeList"] as? Data else { return }
        updateEmployeesWithData(employeeData)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
