//
//  TodoList.swift
//  Checklist
//
//  Created by Yakeem Noel on 7/12/19.
//  Copyright © 2019 Yakeem Noel. All rights reserved.
//

import Foundation

class TodoList {

    enum Priority: Int, CaseIterable {
        case high, medium, low, no

    }

    private var highPriorityTodos: [Checklistitem] = []
    private var mediumPriorityTodos: [Checklistitem] = []
    private var lowPritorityTodos: [Checklistitem] = []
    private var noPritorityTodos: [Checklistitem] = []


    init() {

        let row0Item = Checklistitem()
        let row1Item = Checklistitem()
        let row2Item = Checklistitem()
        let row3Item = Checklistitem()
        let row4Item = Checklistitem()
        let row5Item = Checklistitem()
        let row6Item = Checklistitem()
        let row7Item = Checklistitem()
        let row8Item = Checklistitem()
        let row9Item = Checklistitem()

        row0Item.text = "Take a jog"
        row1Item.text = "Watch a movie"
        row2Item.text = "Code an app"
        row3Item.text = "Walk the dog"
        row4Item.text = "Study design patterns"
        row5Item.text = "Play Basketball"
        row6Item.text = "Do HW"
        row7Item.text = "Take a nap"
        row8Item.text = "Listen to music"
        row9Item.text = "Change oil in car"

        addTodo(row0Item, for: .medium)
        addTodo(row1Item, for: .low)
        addTodo(row2Item, for: .high)
        addTodo(row3Item, for: .no)
        addTodo(row4Item, for: .high)
        addTodo(row5Item, for: .high)
        addTodo(row6Item, for: .medium)
        addTodo(row7Item, for: .no)
        addTodo(row8Item, for: .medium)
        addTodo(row9Item, for: .low)
        
    }

    func addTodo(_ item: Checklistitem, for priority: Priority, at index: Int = -1) {
        switch priority {
        case .high:
            if index < 0 {
                highPriorityTodos.append(item)
            } else {
                highPriorityTodos.insert(item, at: index)
            }
        case .medium:
            if index < 0 {
                mediumPriorityTodos.append(item)
            } else {
            mediumPriorityTodos.insert(item, at: index)
            }
        case .low:
            if index < 0 {
            lowPritorityTodos.append(item)
            } else {
                lowPritorityTodos.insert(item, at: index)
            }
        case .no:
            if index < 0 {
                noPritorityTodos.append(item)
            } else {
            noPritorityTodos.insert(item, at: index)
            }
        }
    }
    func todoList(for priority: Priority) -> [Checklistitem] {
        switch priority {
        case .high:
           return highPriorityTodos
        case .medium:
           return mediumPriorityTodos
        case .low:
           return lowPritorityTodos
        case .no:
           return noPritorityTodos
        }
    }


    func newToDo() -> Checklistitem {
        let item = Checklistitem()
        item.text = randomTitle()
        item.checked = true
        mediumPriorityTodos.append(item)

        return item
        
    }

    func move(item: Checklistitem, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int) {
        remove(item, from: sourcePriority, at: sourceIndex)
        addTodo(item, for: destinationPriority, at: destinationIndex)

    }

    func remove(_ item: Checklistitem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPritorityTodos.remove(at: index)
        case .no:
            noPritorityTodos.remove(at: index)
        }

    }


    private func randomTitle() -> String {

        var titles = ["New todo item","Generic todo","Fill me out","I need something to do","Much to do"]
        let randomNumber = Int.random(in: 0 ... titles.count - 1)
        return titles[randomNumber]

    }
}
