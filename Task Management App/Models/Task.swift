//
//  Task.swift
//  Task Management App
//
//  Created by Vinay Bharwani on 28/06/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation

// Model to hold data
struct Task{
    var ID: String
    var title: String
    var endDate: Date
    var priority: String
    var description: String
    
    // MARK: initializers
    init(ID:String, title:String, endDate:Date, priority:String, description:String) {
        self.ID = ID
        self.title = title
        self.endDate = endDate
        self.priority = priority
        self.description = description
    }
        
//  to check if Task is added for date before current date
    var pastEndDate: Bool{
        return Date().compare(self.endDate) == ComparisonResult.orderedDescending
    }
    
    
//  to check if Task is added without title
    var emptyTitle: Bool{
        return self.title.isEmpty
    }
    
}
