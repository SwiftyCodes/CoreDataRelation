//
//  CategoriesViewController.swift
//  ExpensesCoreData
//
//  Created by Shawn Moore on 11/9/17.
//  Copyright © 2017 Shawn Moore. All rights reserved.
//

import UIKit
import CoreData
class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    var categoriesArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedObjectContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        let fetchRequest : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoriesArray = try managedObjectContext.fetch(fetchRequest)
            categoriesTableView.reloadData()
        }catch{
            print("Fetching of the categories failed!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ExpensesViewController,
             let selectedRow = categoriesTableView.indexPathForSelectedRow?.row else {
            return
        }
        destination.category = categoriesArray[selectedRow]
    }
    
    func deleteCategory(indexPath : IndexPath) {
        let category = categoriesArray[indexPath.row]
        guard let managedObjectContext = category.managedObjectContext else {
            return
        }
        managedObjectContext.delete(category)
        do{
            try managedObjectContext.save()
            categoriesArray.remove(at: indexPath.row)
            categoriesTableView.deleteRows(at: [indexPath], with: .automatic)
        }catch{
            print("Category was not deleted!")
            //Deleting row option stays there still!
            categoriesTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let singleCategory = categoriesArray[indexPath.row]
        cell.textLabel?.text = singleCategory.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategory(indexPath: indexPath)
        }
    }
}
