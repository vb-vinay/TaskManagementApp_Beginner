//
//  HomeScreenViewController.swift ...........ViewController
//  Task Management App
//
//  Created by Vinay Bharwani on 25/06/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var taskList: [Task] = []
    static var sortCounter = 1
    @IBOutlet weak var tableView: UITableView!
    
    
//  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGray
    }
    
    
//  viewWillAppear to refreshList
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList(1)
    }

//  conforms UITableViewDataSource
    // MARK: TAbleView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//  conforms UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
//  conforms UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Task instance
        let task = taskList[indexPath.row]
        
        // row cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        // populating TextLabel
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 26.0)
        cell.textLabel?.text = task.title
        
        // populating detailTextLabel with date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a"
        cell.detailTextLabel?.text = dateFormatter.string(from: task.endDate as Date)
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 20.0)
        //cell coloration based on priority
        if task.priority=="Urgent" {
            cell.contentView.backgroundColor = UIColor.red
        } else{
            cell.contentView.backgroundColor = UIColor.green
        }
        
        return cell
    }
    
//  conforms UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // instance of TaskDetail ViewController
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "taskDetailVC") as! TaskDetailViewController
        navigationController?.pushViewController(destinationVC, animated: true)
        
        // array of Tasks
        let arrayOfTasks = TaskManager.sharedInstance.allTasks()
        
        // initializing rowSelectedTask in another VC
        destinationVC.rowSelectedTask = arrayOfTasks[indexPath.row]
    }
    
//  conforms UITableViewDataSource for deletion of rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            // task is removed from User Default
            TaskManager.sharedInstance.removeTask(task)
            //self.navigationItem.rightBarButtonItem!.isEnabled = true
        }
    }
    
    
//  reloading the data
    func refreshList(_ num: Int){
        taskList = TaskManager.sharedInstance.allTasks()
        if num%2 == 0{
            taskList = taskList.sorted(by: {(previous: Task, latest:Task) -> Bool in
                previous.endDate.compare(latest.endDate) == .orderedAscending})
        }
        tableView.reloadData()
    }
    
    
//  sorting the taskList using counter
    @IBAction func sort(_ sender: Any) {
        HomeScreenViewController.sortCounter+=1
        refreshList(HomeScreenViewController.sortCounter)
    }
    
}

