//
//  NoteTableViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 06/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class NoteTableViewController: UIViewController {

    var data = [ tableSections: NoteSection ]()
    
    enum tableSections: Int, CaseIterable {
        case today = 0, tomorrow, future
    }
    
    fileprivate var selectedCellIndexPath: IndexPath?
    fileprivate var snapshot: UIView?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = nil
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longPress)
        
        reloadData()
    }
    
    func reloadData() {
        setSectionsWithNotes()
    }
}

extension NoteTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = tableSections.allCases[section]
        guard let rows = data[tableSection] else {
            return 0
        }
        return rows.values.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let period = tableSections(rawValue: section) ?? tableSections.today
        let date = Date.formatter.string(from: Date())
        switch period {
        case tableSections.today:
            return "Today \(date)"
        case tableSections.tomorrow:
            return "Tomorrow"
        case tableSections.future:
            return "Future"
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        if let tableSection = tableSections(rawValue: indexPath.section),
            let dataSection = data[tableSection] {
                let cellModel = dataSection.values[indexPath.row]
                cell.onBind(cellModel)

                return cell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let tableSection = tableSections(rawValue: indexPath.section),
            let dataSection = data[tableSection] else {
                return
        }
        let dataCell = dataSection.values[indexPath.row]
        let cellViewController = CellViewController()
        cellViewController.data = dataCell
        
        navigationController?.pushViewController(cellViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            guard let tableSection = tableSections(rawValue: indexPath.section),
                let dataSection = self.data[tableSection] else {
                    return
            }
            let note = dataSection.values[indexPath.row]
            
            let deleteOp = RemoveOperation(note, from: FileNotebook.shared)
            
            // FIXME: - No need to load notes from file, need to append data to existing file
            let noteBookToDelete = FileNotebook()
            noteBookToDelete.add(note)
            noteBookToDelete.load(from: deletedFileName)
            let savingDeletedOp = SaveOperation(note, to: noteBookToDelete)
            savingDeletedOp.deletedSave()
            
            self.data[tableSection]?.remove(note)
            
            self.tableView.deleteRows(at: [indexPath], with: .left)
            completion(true)
        }
        action.backgroundColor = .red
        
        return action
    }

    @objc func longPressGestureRecognized(_ longPress: UIGestureRecognizer) {
        let location = longPress.location(in: tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: location) else {
            return
        }
        let state = longPress.state
        switch state {
        case .began:
            self.selectedCellIndexPath = indexPath
            guard let cell = self.tableView.cellForRow(at: indexPath) else {
                return
            }
            self.snapshot = self.getCustomSnapshotFromView(inputView: cell)
            guard let snapshot = self.snapshot else {
                return
            }
            var center = cell.center
            snapshot.center = center
            snapshot.alpha = 0.0
            self.tableView.addSubview(snapshot)
            UIView.animate(withDuration: 0.25, animations: {
                center.y = location.y
                snapshot.center = center
                snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                snapshot.alpha = 0.98
                cell.alpha = 0.0
            }, completion: { (finished) in
                cell.isHidden = true
            })
            break
        case .changed:
            guard let snapshot = self.snapshot else {
                return
            }
            var center = snapshot.center
            center.y = location.y
            snapshot.center = center
            guard let sourceIndexPath = self.selectedCellIndexPath  else {
                return
            }
            if indexPath != sourceIndexPath {
                guard let sourceTableSection = tableSections(rawValue: sourceIndexPath.section),
                    let dataSection = data[sourceTableSection] else {
                        return
                }
                let sourceNote = dataSection.values[sourceIndexPath.row]

                guard let tableSection = tableSections(rawValue: indexPath.section) else {
                    return
                }
                let date: Date = {
                    switch tableSection {
                    case .today:
                        return Date()
                    case .tomorrow:
                        return Date.tomorrow
                    case .future:
                        return Date.future
                    }
                }()
                let note = Note(
                    uid: sourceNote.uid,
                    position: indexPath.row,
                    content: sourceNote.content,
                    importance: sourceNote.importance,
                    expirationDate: date,
                    category: sourceNote.category,
                    reminder: sourceNote.reminder
                )
                self.data[sourceTableSection]?.remove(sourceNote)

                let remove = RemoveOperation(sourceNote, from: FileNotebook.shared)
                
                self.data[tableSection]?.insert(note: note, to: indexPath.row)
                let save = SaveOperation(note, to: FileNotebook.shared)
                
                self.tableView.moveRow(at: sourceIndexPath, to: indexPath)
                self.selectedCellIndexPath = indexPath
            }
            break
        default:
            guard let cell = self.tableView.cellForRow(at: indexPath) else {
                return
            }
            guard  let snapshot = self.snapshot else {
                return
            }
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                snapshot.center = cell.center
                snapshot.transform = CGAffineTransform.identity
                snapshot.alpha = 0
                cell.alpha = 1
            }, completion: { (finished) in
                self.cleanup()
            })
        }
    }
    
    private func cleanup() {
        self.selectedCellIndexPath = nil
        snapshot?.removeFromSuperview()
        self.snapshot = nil
    }
    
    func getCustomSnapshotFromView(inputView: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        if let currentContext = UIGraphicsGetCurrentContext() {
            inputView.layer.render(in: currentContext)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
    
    @objc func settingsButtonPressed(_ sender: UIButton) {
        let settinsViewController = SettingsViewController()
        navigationController?.pushViewController(settinsViewController, animated: true)
    }

    func setSectionsWithNotes() {
        let noteList = FileNotebook.shared.notes
        
        for period in tableSections.allCases {
            let sectionIndex = period.rawValue
            switch sectionIndex {
            case 0:
                let notesInSection = noteList.filter({
                    Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date() )
                })
                data[period] = NoteSection(notes: notesInSection, index: sectionIndex)
                break
            case 1:
                let notesInSection = noteList.filter({
                    Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date.tomorrow )
                })
                data[period] = NoteSection(notes: notesInSection, index: sectionIndex)
                break
            case 2:
                let notesInSection = noteList.filter({
                    Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date.future )
                })
                data[period] = NoteSection(notes: notesInSection, index: sectionIndex)
                break
            default:
                break
            }
        }
    }

}
