//
//  AllListsViewController.swift
//  reminder
//
//  Created by Андрей Глухих on 25/11/2018.
//  Copyright © 2018 scapegoat. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegat, UINavigationControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding item: Checklist) {
        dataModel.checklists.append(item)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing item: Checklist) {
        if let index = dataModel.checklists.index(of:item){
            dataModel.checklists[index] = item
            dataModel.sortChecklists()
            tableView.reloadData()
            navigationController?.popViewController(animated: true)
        }
    }


    var dataModel: DataModel!

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController === self{
            dataModel.indexOfSelectedChecklist = -1
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.loadChecklists()

        navigationController?.delegate = self

        let index = dataModel.indexOfSelectedChecklist
        print(index)
        if index >= 0 && index < dataModel.checklists.count{
            performSegue(withIdentifier: "ShowChecklist", sender: dataModel.checklists[index])
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ReminderViewController
            controller.checklist = sender as? Checklist
        } else{
            if segue.identifier == "AddChecklist"{
                let controller = segue.destination as! ListDetailViewController
                controller.delegate = self
                print("Here")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.checklists.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        performSegue(withIdentifier: "ShowChecklist", sender: dataModel.checklists[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell()
        cell.textLabel?.text = dataModel.checklists[indexPath.row].name
        let uncheckedCount = dataModel.checklists[indexPath.row].countUncheckedItems()
        if dataModel.checklists[indexPath.row].items.count == 0 {
            cell.detailTextLabel?.text = "(No items)"
        } else if uncheckedCount == 0{
            cell.detailTextLabel?.text = "All done!"
        } else {
            cell.detailTextLabel?.text = "\(uncheckedCount) Remaining"
        }
        cell.accessoryType = .detailDisclosureButton
        return cell
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController

        controller.delegate = self
        controller.checklistToEdit = dataModel.checklists[indexPath.row]

        navigationController?.pushViewController(controller, animated: true)
    }

    let reuseIndetifier = "Cell"

    func makeCell() -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndetifier){
            return cell;
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: reuseIndetifier)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dataModel.checklists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
