//
//  ViewController.swift
//  Checklist
//
//  Created by Yakeem Noel on 6/27/19.
//  Copyright © 2019 Yakeem Noel. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    var todoList: TodoList


    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }

    @IBAction func additem(_ sender: Any) {

        let newRowIndex = todoList.todoList(for: .medium).count
        _ = todoList.newToDo()

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows =  tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section) {
                    let todos = todoList.todoList(for: priority)
                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item = todos[rowToDelete]
                    todoList.remove(item, from: priority, at: rowToDelete)
                }
            }

            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true

         }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priorty = priorityForSectionIndex(section) {
            return todoList.todoList(for: priorty).count
    }
        return 0

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        if let priority = priorityForSectionIndex(indexPath.section) {
            let items = todoList.todoList(for: priority)
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }

        if let cell = tableView.cellForRow(at: indexPath) {
            if let priority = priorityForSectionIndex(indexPath.section) {
            let items = todoList.todoList(for: priority)
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }



    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let priority = priorityForSectionIndex(indexPath.section) {
            let item = todoList.todoList(for: priority) [indexPath.row]
            todoList.remove(item, from: priority, at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
            let destPriority = priorityForSectionIndex(destinationIndexPath.section) {

           let item = todoList.todoList(for: srcPriority) [sourceIndexPath.row]
            todoList.move(item: item, from: srcPriority, at: sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
        }

        tableView.reloadData()

    }

    func configureText(for cell: UITableViewCell, with item: Checklistitem) {
        if let checkmarkCell = cell as? CheckListTableViewCell {
            checkmarkCell.todoTextLabel.text = item.text
        }
    }

    func configureCheckmark(for cell: UITableViewCell, with item: Checklistitem) {

        guard let checkmarkCell = cell as? CheckListTableViewCell else {
            return
        }
        if item.checked {
            checkmarkCell.checkmarkLabel.text = "√"
        } else {
            checkmarkCell.checkmarkLabel.text = " "
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AdditemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                addItemViewController.delegate = self
                addItemViewController.todoList = todoList

            }
            
        } else if segue.identifier == "EditItemSegue" {
            if let addItemViewController = segue.destination as?
            ItemDetailViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let priority = priorityForSectionIndex(indexPath.section)
                {
                    let item = todoList.todoList(for: priority) [indexPath.row]
                    addItemViewController.itemToEdit = item
                    addItemViewController.delegate = self

                }
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }



    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high:
                title = "High Priority Todos"
            case .medium:
                title = "Medium Priority Todos"
            case .low:
                title = "Low Pritority Todos"
            case .no:
                title = "Someday Todo Items"
            }
        }
        return title
    }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: Checklistitem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todoList(for: .medium).count - 1
        let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: Checklistitem) {
        for priority in TodoList.Priority.allCases {
            let currentList = todoList.todoList(for: priority)
            if let index = currentList.firstIndex(of: item) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: item)
                }
            }
        }
        navigationController?.popViewController(animated: true)
            }
        }
