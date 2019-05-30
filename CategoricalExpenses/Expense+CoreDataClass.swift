//
//  Expense+CoreDataClass.swift
//  CategoricalExpenses
//
//  Created by chetu on 5/17/19.
//  Copyright © 2019 Shawn Moore. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Expense)
public class Expense: NSManagedObject {

    var date : Date? {
        get {
            return rawDate as Date?
        }
        set {
            rawDate = newValue as NSDate?
        }
    }
    
    convenience init?(name: String?, amount:Double, date:Date?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedObjectContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: Expense.entity(), insertInto: managedObjectContext)
        self.name = name
        self.amount = amount
        self.date = date
    }
    
}
