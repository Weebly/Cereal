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
    fileprivate var employeeEdit: ItemEdit?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadStoredEmployees()

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = self.editButtonItem
    }

    fileprivate func loadStoredEmployees() {
        guard let storedEmployeeData = UserDefaults.standard.object(forKey: "employeeList") as? Data else { return }
        do {
            employees = try CerealDecoder.rootCerealItems(with: storedEmployeeData)
        } catch let error {
            NSLog("Couldn't decode employees due to error: \(error)")
        }
    }

    fileprivate func storeEmployees() {
        do {
            let data = try CerealEncoder.dataWithRootItem(employees)
            UserDefaults.standard.set(data, forKey: "employeeList")
            UserDefaults.standard.synchronize()

            if WCSession.isSupported() && WCSession.default().isReachable {
                WCSession.default().sendMessage(["action": "employeesUpdated", "employeeList": data], replyHandler: nil, errorHandler: { error in
                    NSLog("Couldn't update watch app due to error: \(error)")
                })
            }
        } catch let error {
            NSLog("Couldn't write employees to defaults due to error: \(error)")
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        enum SegueType: String {
            case CreateEmployee = "createEmployee"
            case EditEmployee = "editEmployee"
        }

        guard let segueIdentifier = segue.identifier, let segueType = SegueType(rawValue: segueIdentifier) else { return }

        switch segueType {
        case .CreateEmployee:
            let controller = (segue.destination as! UINavigationController).topViewController as! EditEmployeeViewController
            controller.employee = Employee()
            controller.delegate = self
            controller.title = "Add Employee"
            employeeEdit = .creating
        case .EditEmployee:
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { fatalError() }
            let controller = segue.destination as! EditEmployeeViewController
            controller.employee = employees[indexPath.row]
            controller.delegate = self
            controller.navigationItem.leftBarButtonItem = nil
            controller.title = "Update Employee"
            employeeEdit = .editing(indexPath)
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let employee = employees[indexPath.row]
        let genderString = employee.gender == .male ? "👨🏻" : "👩🏻"

        cell.textLabel!.text = "\(employee.name), \(String(employee.age))yo \(genderString)"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            employees.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            storeEmployees()
        }
    }

    @IBAction func unwindToEmployeeList(_ segue: UIStoryboardSegue) { }

}

extension EmployeeListViewController: EditEmployeeViewControllerDelegate {
    func editEmployeeViewController(_ editEmployeeViewController: EditEmployeeViewController, didSaveEmployee employee: Employee) {
        guard let employeeEdit = employeeEdit else { return }

        switch employeeEdit {
        case .creating:
            employees.append(employee)
            tableView.insertRows(at: [IndexPath(row: employees.count - 1, section: 0)], with: .fade)
        case .editing(let indexPath):
            employees[indexPath.row] = employee
            tableView.reloadRows(at: [indexPath], with: .fade)
        }

        storeEmployees()
    }
}

