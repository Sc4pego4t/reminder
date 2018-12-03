//
//  Checklist.swift
//  reminder
//
//  Created by Андрей Глухих on 02/12/2018.
//  Copyright © 2018 scapegoat. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    init(_ name: String) {
        self.name=name
    }
    var name: String
    var items: [ReminderItem] = []

    func countUncheckedItems() -> Int{
        var counter = 0
        for item in items where !item.isChecked{
            counter += 1
        }
        return counter
    }
}
