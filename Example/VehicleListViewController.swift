//
//  VehicleListViewController.swift
//  Cereal
//
//  Created by James Richard on 9/30/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Cereal
import UIKit

class VehicleListViewController: UITableViewController {
    var vehicles = [Vehicle]()
    fileprivate var vehicleEdit: ItemEdit?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadStoredVehicles()

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = self.editButtonItem
    }

    fileprivate func loadStoredVehicles() {
        guard let storedVehicleData = UserDefaults.standard.object(forKey: "vehicleList") as? Data else { return }
        do {
            vehicles = try CerealDecoder.rootIdentifyingCerealItems(with: storedVehicleData).CER_casted()
        } catch let error {
            NSLog("Couldn't decode employees due to error: \(error)")
        }
    }

    fileprivate func storeVehicles() {
        do {
            UserDefaults.standard.set(try CerealEncoder.dataWithRootItem(vehicles.CER_casted() as [IdentifyingCerealType]), forKey: "vehicleList")
            UserDefaults.standard.synchronize()
        } catch let error {
            NSLog("Couldn't write employees to defaults due to error: \(error)")
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        enum SegueType: String {
            case CreateNewCar = "createNewCar"
            case CreateNewTrain = "createNewTrain"
            case EditCar = "editCar"
            case EditTrain = "editTrain"
        }

        guard let segueIdentifier = segue.identifier, let segueType = SegueType(rawValue: segueIdentifier) else { return }

        switch segueType {
        case .CreateNewCar:
            let controller = (segue.destination as! UINavigationController).topViewController as! EditCarViewController
            controller.car = Car(make: "", model: "", cylinders: 2)
            controller.delegate = self
            controller.title = "Add Car"
            vehicleEdit = .creating
        case .CreateNewTrain:
            let controller = (segue.destination as! UINavigationController).topViewController as! EditTrainViewController
            controller.train = Train(make: "", model: "", cars: 2)
            controller.delegate = self
            controller.title = "Add Train"
            vehicleEdit = .creating
        case .EditCar:
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { fatalError() }
            let controller = segue.destination as! EditCarViewController
            let car = vehicles[indexPath.row] as! Car
            controller.car = car
            controller.delegate = self
            controller.title = "Update Car"
            controller.navigationItem.leftBarButtonItem = nil
            vehicleEdit = .editing(indexPath)
        case .EditTrain:
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { fatalError() }
            let controller = segue.destination as! EditTrainViewController
            let train = vehicles[indexPath.row] as! Train
            controller.train = train
            controller.delegate = self
            controller.title = "Update Train"
            controller.navigationItem.leftBarButtonItem = nil
            vehicleEdit = .editing(indexPath)
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let vehicle = vehicles[indexPath.row]

        cell.textLabel!.text = vehicle.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            vehicles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            storeVehicles()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let vehicle = vehicles[indexPath.row]
        if vehicle is Car {
            performSegue(withIdentifier: "editCar", sender: cell)
        } else if vehicle is Train {
            performSegue(withIdentifier: "editTrain", sender: cell)
        } else {
            fatalError("Unsupported vehicle type")
        }
    }
    
    @IBAction func unwindToVehicleList(_ segue: UIStoryboardSegue) { }

    @IBAction func createNewVehiclePressed() {
        let alertController = UIAlertController(title: "New Vehicle", message: "Which type of vehicle would you like to create?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Car", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "createNewCar", sender: self)
        }))

        alertController.addAction(UIAlertAction(title: "Train", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "createNewTrain", sender: self)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    fileprivate func handleVehicleSave(_ vehicle: Vehicle) {
        guard let vehicleEdit = vehicleEdit else { return }

        switch vehicleEdit {
        case .creating:
            vehicles.append(vehicle)
            tableView.insertRows(at: [IndexPath(row: vehicles.count - 1, section: 0)], with: .fade)
        case .editing(let indexPath):
            vehicles[indexPath.row] = vehicle
            tableView.reloadRows(at: [indexPath], with: .fade)
        }

        storeVehicles()
    }
}

extension VehicleListViewController: EditCarViewControllerDelegate {
    func editCarViewController(_ editCarViewController: EditCarViewController, didSaveCar car: Car) {
        handleVehicleSave(car as Vehicle)
    }
}

extension VehicleListViewController: EditTrainViewControllerDelegate {
    func editTrainViewController(_ editTrainViewController: EditTrainViewController, didSaveTrain train: Train) {
        handleVehicleSave(train as Vehicle)
    }
}
