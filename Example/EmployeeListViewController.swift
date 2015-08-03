//
//  EmployeeListViewController.swift
//  Example
//
//  Created by James Richard on 9/29/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Cereal
import UIKit
import WatchConnectivity

class EmployeeListViewController: UITableViewController {
    var employees = [Employee]()
    private var employeeEdit: ItemEdit?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadStoredEmployees()

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    private func loadStoredEmployees() {
        guard let storedEmployeeData = NSUserDefaults.standardUserDefaults().objectForKey("employeeList") as? NSData else { return }
        do {
            employees = try CerealDecoder.rootCerealItemsWithData(storedEmployeeData)
        } catch let error {
            NSLog("Couldn't decode employees due to error: \(error)")
        }
    }

    private func storeEmployees() {
        do {
            let data = try CerealEncoder.dataWithRootItem(employees)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "employeeList")
            NSUserDefaults.standardUserDefaults().synchronize()

            if WCSession.isSupported() && WCSession.defaultSession().reachable {
                WCSession.defaultSession().sendMessage(["action": "employeesUpdated", "employeeList": data], replyHandler: nil, errorHandler: { error in
                    NSLog("Couldn't update watch app due to error: \(error)")
                })
            }
        } catch let error {
            NSLog("Couldn't write employees to defaults due to error: \(error)")
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        enum SegueType: String {
            case CreateEmployee = "createEmployee"
            case EditEmployee = "editEmployee"
        }

        guard let segueIdentifier = segue.identifier, segueType = SegueType(rawValue: segueIdentifier) else { return }

        switch segueType {
        case .CreateEmployee:
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! EditEmployeeViewController
            controller.employee = Employee()
            controller.delegate = self
            controller.title = "Add Employee"
            employeeEdit = .Creating
        case .EditEmployee:
            guard let cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) else { fatalError() }
            let controller = segue.destinationViewController as! EditEmployeeViewController
            controller.employee = employees[indexPath.row]
            controller.delegate = self
            controller.navigationItem.leftBarButtonItem = nil
            controller.title = "Update Employee"
            employeeEdit = .Editing(indexPath)
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let employee = employees[indexPath.row]
        let genderString = employee.gender == .Male ? "👨🏻" : "👩🏻"

        cell.textLabel!.text = "\(employee.name), \(String(employee.age))yo \(genderString)"
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            employees.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            storeEmployees()
        }
    }

    @IBAction func unwindToEmployeeList(segue: UIStoryboardSegue) { }

}

extension EmployeeListViewController: EditEmployeeViewControllerDelegate {
    func editEmployeeViewController(editEmployeeViewController: EditEmployeeViewController, didSaveEmployee employee: Employee) {
        guard let employeeEdit = employeeEdit else { return }

        switch employeeEdit {
        case .Creating:
            employees.append(employee)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: employees.count - 1, inSection: 0)], withRowAnimation: .Fade)
        case .Editing(let indexPath):
            employees[indexPath.row] = employee
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }

        storeEmployees()
    }
}

