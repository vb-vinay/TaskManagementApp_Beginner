    //
//  TaskDetailViewController.swift
//  Task Management App
//
//  Created by Vinay Bharwani on 28/06/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
//  variables
    var tempRowValue: Int = 0
    var rowSelectedForUpdate: Int = 0
    var rowSelectedTask: Task? = nil
    var pickerValues = ["Urgent","Normal"] // use enum here
    
//  outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var endDateDatePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
//  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding border to the Description Text View
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 5.0
        
    }
    
    
//  viewWillAppear to populate the view with the already stored values for corresponding selected row
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // this confirms that row is selected for updation and is not nil
        if let rowSelectedTask = rowSelectedTask{
            rowSelectedForUpdate+=1
            populate(rowSelectedTask)
        }
    }
    
    
//  conforms pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//  conforms pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
//  displays values in PickerView from dataSource i.e. values
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        tempRowValue = row
        return pickerValues[row]
    }
    
//  when back button is clicked
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
//  when save bar button is clicked
    @IBAction func save(_ sender: Any) {
        // Task object populated with values selected by user on runtime
        let task = Task(ID: UUID().uuidString, title: titleTextField.text!, endDate: endDateDatePicker.date, priority: pickerValues[tempRowValue], description: descriptionTextView.text!)
        
        // push alertAction if title of task is not entered
        if task.emptyTitle{
            let alertController = UIAlertController(title: "Failed", message: "Please enter the title", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(alerAction)
            present(alertController,animated: true,completion: nil)
        }
            
            // push alertAction if selected date is less than current date
        else if task.pastEndDate{
            let alertController = UIAlertController(title: "Failed", message: "Please select valid Date format", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(alerAction)
            present(alertController,animated: true,completion: nil)
        }
            
            // saving the values by adding task
        else{
            // values have to be updated so old selected task will be removed from User Defaults
            if rowSelectedForUpdate>0{
                TaskManager.sharedInstance.removeTask(rowSelectedTask!)
            }
            
            // new task is added to User Defaults
            TaskManager.sharedInstance.addTask(task)
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
//  populate view
    func populate(_ task: Task){
        
        titleTextField.text = task.title
        endDateDatePicker.date = task.endDate
        descriptionTextView.text = task.description
        if let row = pickerValues.firstIndex(of: task.priority){
            pickerView.selectRow(row, inComponent: 0, animated: false)
        }
    }
}
