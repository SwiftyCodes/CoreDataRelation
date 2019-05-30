//
//  ExpensesViewController.swift
//  Expenses
//
//  Created by Shawn Moore on 11/6/17.
//  Copyright © 2017 Shawn Moore. All rights reserved.
//

import UIKit
import CoreData
class ExpensesViewController: UIViewController {

    @IBOutlet weak var expensesTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    var category : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expensesTableView.reloadData()
    }

    @IBAction func addNewExpense(_ sender: Any) {
        performSegue(withIdentifier: "showExpense", sender: self)
    }
    
    func deleteExpense(indexPath:IndexPath) {
        guard let expenseToBeDeleted = category?.expenses?[indexPath.row], let managedObjectContext = expenseToBeDeleted.managedObjectContext else {
           return
        }
        managedObjectContext.delete(expenseToBeDeleted)
        do{
            try managedObjectContext.save()
            //IMportant Note: Here we are not removing the data from the Array as we were doing in the categories View Controller because here we haev the relationship cascade and core data is doing that for us!
            expensesTableView.deleteRows(at: [indexPath], with: .automatic)
        }catch{
            print("Expense Deleted successfully!")
            expensesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
}

extension ExpensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.expenses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expensesTableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        let singleExpense = category?.expenses?[indexPath.row]
        cell.textLabel?.text = singleExpense?.name
        if let dateValue = singleExpense?.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: dateValue)
        }
        return cell
    }
}

extension ExpensesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showExpense", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NewExpenseViewController else {
            return
        }
        destination.category = category
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteExpense(indexPath: indexPath)
        }
    }
}


