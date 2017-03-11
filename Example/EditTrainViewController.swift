//
//  EditTrainViewController.swift
//  Cereal
//
//  Created by James Richard on 9/30/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import UIKit

protocol EditTrainViewControllerDelegate: class {
    func editTrainViewController(_ editTrainViewController: EditTrainViewController, didSaveTrain train: Train)
}

class EditTrainViewController: UIViewController {
    var train: Train!
    weak var delegate: EditTrainViewControllerDelegate?
    @IBOutlet var makeTextField: UITextField!
    @IBOutlet var modelTextField: UITextField!
    @IBOutlet var carsLabel: UILabel!
    @IBOutlet var stepperView: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeTextField.text = train.make
        modelTextField.text = train.model
        carsLabel.text = String(train.cars)
        stepperView.value = Double(train.cars)
    }

    @IBAction func savePressed() {
        delegate?.editTrainViewController(self, didSaveTrain: train)
        performSegue(withIdentifier: "UnwindToVehicleList", sender: self)
    }

    @IBAction func textValueChanged(_ textField: UITextField) {
        switch textField {
        case makeTextField: train = Train(make: textField.text ?? "", model: train.model, cars: train.cars)
        case modelTextField: train = Train(make: train.make, model: textField.text ?? "", cars: train.cars)
        default: break
        }
    }

    @IBAction func cylindersStepperChanged(_ stepper: UIStepper) {
        let cars = Int(stepper.value)
        train.cars = cars
        carsLabel.text = String(cars)
    }
}
