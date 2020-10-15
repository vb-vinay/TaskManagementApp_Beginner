//
//  TaskManager.swift
//  Task Management App
//
//  Created by Vinay Bharwani on 28/06/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation
class TaskManager {
    
//  creating singleton instance
    static let sharedInstance = TaskManager()
    private init() { }      // to make sure that initialization is atomic 
    
//  variable
    let KEY = "tasks"

    
//  adding Task to User Defaults
    func addTask(_ task: Task) {
        
        // retrives empty dictionary if none exists
        var taskDictionary = UserDefaults.standard.dictionary(forKey: KEY) ?? [:]
        
        // Key-Value pairs stored as Values at unique-Key(String-task.ID)
        taskDictionary[task.ID] = ["ID" : task.ID, "title" : task.title, "endDate" : task.endDate, "priority": task.priority, "description": task.description]
        
        // setting dictionary to User Defaults
        UserDefaults.standard.set(taskDictionary, forKey: KEY)
        
    }
    
    
//  loading all the stored Tasks from User Defaults
    func allTasks() -> [Task] {
        
        // key-->uniquely generated string,  value-->[key:value]
        let taskDictionary = UserDefaults.standard.dictionary(forKey: KEY) as? [String : [String: Any]] ?? [:]
        
        // extracting only the values of dictionary
        let items = Array(taskDictionary.values)
        
        // creating an array of type Task
        let taskArray = items.map({Task(ID: ($0["ID"] as! String),
                                        title: $0["title"] as! String,
                                        endDate: $0["endDate"] as! Date,
                                        priority: $0["priority"] as! String,
                                        description: $0["description"] as! String)})
        
        // sorting the array based on priority and returning
        return taskArray.sorted(by: {(previous: Task, latest:Task) -> Bool in
            previous.priority.compare(latest.priority) == .orderedDescending})
    
    }
    
    
//  removing the task from User
    func removeTask(_ task: Task) {
        if var taskItems = UserDefaults.standard.dictionary(forKey: KEY) {
            taskItems.removeValue(forKey: task.ID)
            UserDefaults.standard.set(taskItems, forKey: KEY)
        }
    }

}
