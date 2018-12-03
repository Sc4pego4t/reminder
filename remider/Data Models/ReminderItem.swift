//
//  ReminderItem.swift
//  reminder
//
//  Created by Андрей Глухих on 19/11/2018.
//  Copyright © 2018 scapegoat. All rights reserved.
//

import Foundation

class ReminderItem:NSObject,Codable {
    var textContent: String
    var isChecked: Bool

    init(textContent:String, isChecked:Bool) {
        self.textContent = textContent
        self.isChecked = isChecked
    }
    
}
