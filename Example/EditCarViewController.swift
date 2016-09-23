//
//  EditCarViewController.swift
//  Cereal
//
//  Created by James Richard on 9/30/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import UIKit

protocol EditCarViewControllerDelegate: class {
    func editCarViewController(_ editCarViewController: EditCarViewController, didSaveCar car: Car)
}

class EditCarViewController: UIViewController {
    var car: Car!
    weak var delegate: EditCarViewControllerDelegate?
    @IBOutlet var makeTextField: UITextField!
    @IBOutlet var modelTextField: UITextField!
    @IBOutlet var cylindersLabel: UILabel!
    @IBOutlet var stepperView: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeTextField.text = car.make
        modelTextField.text = car.model
        cylindersLabel.text = String(car.cylinders)
        stepperView.value = Double(car.cylinders)
    }

    @IBAction func savePressed() {
        delegate?.editCarViewController(self, didSaveCar: car)
        performSegue(withIdentifier: "UnwindToVehicleList", sender: self)
    }

    @IBAction func textValueChanged(_ textField: UITextField) {
        switch textField {
        case makeTextField: car = Car(make: textField.text ?? "", model: car.model, cylinders: car.cylinders)
        case modelTextField: car = Car(make: car.make, model: textField.text ?? "", cylinders: car.cylinders)
        default: break
        }
    }

    @IBAction func cylindersStepperChanged(_ stepper: UIStepper) {
        let cylinders = Int(stepper.value)
        car = Car(make: car.make, model: car.model, cylinders: cylinders)
        cylindersLabel.text = String(cylinders)
    }
}
