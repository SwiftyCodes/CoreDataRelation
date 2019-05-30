//
//  Category+CoreDataClass.swift
//  CategoricalExpenses
//
//  Created by chetu on 5/17/19.
//  Copyright © 2019 Shawn Moore. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    
    var expenses : [Expense]? {
        get {
            return self.rawExpenses?.array as? [Expense]
        }
    }
    
    convenience init?(title : String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedObjectContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        self.init(entity: Category.entity(), insertInto: managedObjectContext)
        self.title = title
    }
}
