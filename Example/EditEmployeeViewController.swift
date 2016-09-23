//
//  EditEmployeeViewController.swift
//  Cereal
//
//  Created by James Richard on 9/29/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import UIKit

protocol EditEmployeeViewControllerDelegate: class {
    func editEmployeeViewController(_ editEmployeeViewController: EditEmployeeViewController, didSaveEmployee employee: Employee)
}

class EditEmployeeViewController: UIViewController {
    var employee: Employee!
    weak var delegate: EditEmployeeViewControllerDelegate?
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var stepperView: UIStepper!
    @IBOutlet var genderControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = employee.name
        ageLabel.text = String(employee.age)
        stepperView.value = Double(employee.age)
        genderControl.selectedSegmentIndex = employee.gender.rawValue
    }

    @IBAction func savePressed() {
        delegate?.editEmployeeViewController(self, didSaveEmployee: employee)
        performSegue(withIdentifier: "UnwindToEmployeeList", sender: self)
    }

    @IBAction func nameValueChanged(_ textField: UITextField) {
        employee.name = textField.text ?? ""
    }

    @IBAction func ageStepperChanged(_ stepper: UIStepper) {
        let age = Int(stepper.value)
        employee.age = age
        ageLabel.text = String(age)
    }

    @IBAction func genderChanged(_ control: UISegmentedControl) {
        employee.gender = Gender(rawValue: control.selectedSegmentIndex)!
    }
}
