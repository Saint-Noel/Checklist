//
//  Checklistitem.swift
//  Checklist
//
//  Created by Yakeem Noel on 7/12/19.
//  Copyright © 2019 Yakeem Noel. All rights reserved.
//

import Foundation

class Checklistitem: NSObject {

    @objc var text = ""
    var checked = false

    func toggleChecked() {
        checked = !checked
        
    }
}
