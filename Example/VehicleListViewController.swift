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
    private var vehicleEdit: ItemEdit?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadStoredVehicles()

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    private func loadStoredVehicles() {
        guard let storedVehicleData = NSUserDefaults.standardUserDefaults().objectForKey("vehicleList") as? NSData else { return }
        do {
            vehicles = try CerealDecoder.rootIdentifyingCerealItemsWithData(storedVehicleData).CER_casted()
        } catch let error {
            NSLog("Couldn't decode employees due to error: \(error)")
        }
    }

    private func storeVehicles() {
        do {
            NSUserDefaults.standardUserDefaults().setObject(try CerealEncoder.dataWithRootItem(vehicles.CER_casted() as [IdentifyingCerealType]), forKey: "vehicleList")
            NSUserDefaults.standardUserDefaults().synchronize()
        } catch let error {
            NSLog("Couldn't write employees to defaults due to error: \(error)")
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        enum SegueType: String {
            case CreateNewCar = "createNewCar"
            case CreateNewTrain = "createNewTrain"
            case EditCar = "editCar"
            case EditTrain = "editTrain"
        }

        guard let segueIdentifier = segue.identifier, segueType = SegueType(rawValue: segueIdentifier) else { return }

        switch segueType {
        case .CreateNewCar:
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! EditCarViewController
            controller.car = Car(make: "", model: "", cylinders: 2)
            controller.delegate = self
            controller.title = "Add Car"
            vehicleEdit = .Creating
        case .CreateNewTrain:
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! EditTrainViewController
            controller.train = Train(make: "", model: "", cars: 2)
            controller.delegate = self
            controller.title = "Add Train"
            vehicleEdit = .Creating
        case .EditCar:
            guard let cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) else { fatalError() }
            let controller = segue.destinationViewController as! EditCarViewController
            let car = vehicles[indexPath.row] as! Car
            controller.car = car
            controller.delegate = self
            controller.title = "Update Car"
            controller.navigationItem.leftBarButtonItem = nil
            vehicleEdit = .Editing(indexPath)
        case .EditTrain:
            guard let cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) else { fatalError() }
            let controller = segue.destinationViewController as! EditTrainViewController
            let train = vehicles[indexPath.row] as! Train
            controller.train = train
            controller.delegate = self
            controller.title = "Update Train"
            controller.navigationItem.leftBarButtonItem = nil
            vehicleEdit = .Editing(indexPath)
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let vehicle = vehicles[indexPath.row]

        cell.textLabel!.text = vehicle.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            vehicles.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            storeVehicles()
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
        let vehicle = vehicles[indexPath.row]
        if vehicle is Car {
            performSegueWithIdentifier("editCar", sender: cell)
        } else if vehicle is Train {
            performSegueWithIdentifier("editTrain", sender: cell)
        } else {
            fatalError("Unsupported vehicle type")
        }
    }
    
    @IBAction func unwindToVehicleList(segue: UIStoryboardSegue) { }

    @IBAction func createNewVehiclePressed() {
        let alertController = UIAlertController(title: "New Vehicle", message: "Which type of vehicle would you like to create?", preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Car", style: .Default, handler: { _ in
            self.performSegueWithIdentifier("createNewCar", sender: self)
        }))

        alertController.addAction(UIAlertAction(title: "Train", style: .Default, handler: { _ in
            self.performSegueWithIdentifier("createNewTrain", sender: self)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }

    private func handleVehicleSave(vehicle: Vehicle) {
        guard let vehicleEdit = vehicleEdit else { return }

        switch vehicleEdit {
        case .Creating:
            vehicles.append(vehicle)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: vehicles.count - 1, inSection: 0)], withRowAnimation: .Fade)
        case .Editing(let indexPath):
            vehicles[indexPath.row] = vehicle
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }

        storeVehicles()
    }
}

extension VehicleListViewController: EditCarViewControllerDelegate {
    func editCarViewController(editCarViewController: EditCarViewController, didSaveCar car: Car) {
        handleVehicleSave(car as Vehicle)
    }
}

extension VehicleListViewController: EditTrainViewControllerDelegate {
    func editTrainViewController(editTrainViewController: EditTrainViewController, didSaveTrain train: Train) {
        handleVehicleSave(train as Vehicle)
    }
}
