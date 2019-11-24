//
//  DeletedNotesViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 19/11/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class DeletedNotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var noteList = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Deleted Notes"
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        navigationItem.rightBarButtonItem = editButtonItem

        reloadData()
    }

    func reloadData() {
        let notebook = FileNotebook()
        let loadDeletedOp = LoadOperation(notebook: notebook)
        loadDeletedOp.deletedLoad()
        guard let notes = loadDeletedOp.result else {
            return
        }
        noteList = notes
    }

    @objc func setNotestoEdit() {
//        tableView.setEditing(true, animated: false)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(reloadData))
    }
}

extension DeletedNotesViewController: UITableViewDelegate {

}

extension DeletedNotesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as! NoteTableViewCell
        cell.onBind(noteList[indexPath.row])
        cell.setEditing(true, animated: true)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let restore = restoreFromDeleted(at: indexPath)
        return UISwipeActionsConfiguration(actions: [restore])
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            let note = self.noteList[indexPath.row]
            let fileNotebook = FileNotebook()
            fileNotebook.load(from: deletedFileName)
            let removeOp = RemoveOperation(note, from: fileNotebook)
            removeOp.removeFromDeleted()
            self.noteList.remove(at: indexPath.row)

            self.tableView.deleteRows(at: [indexPath], with: .automatic)

            completion(true)
        }
        action.backgroundColor = .red
        return action
    }

    func restoreFromDeleted(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Restore") { (action, view, completion) in
            let note = self.noteList[indexPath.row]
            let fileNotebook = FileNotebook()
            fileNotebook.load(from: deletedFileName)
            let removeOp = RemoveOperation(note, from: fileNotebook)
            removeOp.removeFromDeleted()

            let saveOp = SaveOperation.init(note, to: FileNotebook.shared)
            saveOp.update()

            self.noteList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

            completion(true)
        }
        action.backgroundColor = .gray
        return action
    }
}
