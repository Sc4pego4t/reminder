//
//  ViewController.swift
//  remider
//
//  Created by Андрей Глухих on 18/11/2018.
//  Copyright © 2018 scapegoat. All rights reserved.
//

import UIKit

class ReminderViewController: UITableViewController, ItemDetailViewControllerDelegat {

    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ReminderItem) {
        checklist.items.append(item)
        tableView.insertRows(at: [IndexPath(row: checklist.items.count-1, section: 0)], with: .automatic)
        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ReminderItem) {
        if let index = checklist.items.index(of:item){
            checklist.items[index] = item
            let indexPath = IndexPath(row: index, section: 0)
            configureText(tableView.cellForRow(at: indexPath)!, at: indexPath.row)
        }
        navigationController?.popViewController(animated: true)
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier!)
        switch segue.identifier {
        case "AddItem":
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        case "EditItem":
            let controller = segue.destination as! ItemDetailViewController
            controller.itemToEdit = checklist.items[(tableView.indexPath(for: sender as! UITableViewCell)?.row)!]
            controller.delegate = self
        default:
            print("default")
        }
    }

    var checklist:Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        title=checklist.name
        navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

        configureText(cell, at: indexPath.row)
        congigureCheckmark(cell, at: indexPath.row)

        return cell;
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }


    func congigureCheckmark(_ cell: UITableViewCell, at index:Int){
        let labelCheckmark = cell.viewWithTag(101) as! UILabel
        if checklist.items[index].isChecked {
            labelCheckmark.isHidden = false
        } else {
            labelCheckmark.isHidden = true
        }
    }

    func configureText(_ cell: UITableViewCell, at index:Int){
        let label = cell.viewWithTag(100) as! UILabel
        label.text = checklist.items[index].textContent
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            checklist.items[indexPath.row].isChecked = !checklist.items[indexPath.row].isChecked
            congigureCheckmark(cell, at: indexPath.row)

        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }



}

