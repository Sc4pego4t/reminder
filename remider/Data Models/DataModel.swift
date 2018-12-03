//
//  DataModel.swift
//  reminder
//
//  Created by Андрей Глухих on 02/12/2018.
//  Copyright © 2018 scapegoat. All rights reserved.
//

import Foundation

class DataModel {
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    var checklists: [Checklist]=[]
    func saveChecklists(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(checklists)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch let error{
            print(error)
        }
    }

    func sortChecklists() {
        checklists.sort(by: {
            checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
    }

    let defaultIndex = "ChecklistIndex"
    let defaultFirstTime = "FirstTime"

    var indexOfSelectedChecklist: Int{
        get{
            return UserDefaults.standard.integer(forKey: defaultIndex)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: defaultIndex)
        }
    }

    func registerDefaults(){
        let dictionary: [String : Any] = [defaultIndex:-1, defaultFirstTime: true]
        UserDefaults.standard.register(defaults: dictionary)
    }

    func handleFirstTime(){
        if UserDefaults.standard.bool(forKey: defaultFirstTime){
            checklists.append(Checklist("List"))
            indexOfSelectedChecklist = 0
            UserDefaults.standard.set(false, forKey: defaultFirstTime)
        }
    }

    func loadChecklists(){
        let decoder = PropertyListDecoder()
        do{
            let data = try Data(contentsOf: dataFilePath().absoluteURL)
            checklists = try decoder.decode([Checklist].self, from: data)
            sortChecklists()
        } catch let error{
            print(error)
        }
    }

    func documentDirectory() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func dataFilePath() -> URL {
        return documentDirectory().appendingPathComponent("Reminder.plist")
    }
}
