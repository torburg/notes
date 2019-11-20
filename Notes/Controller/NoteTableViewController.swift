//
//  NoteTableViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 06/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class NoteTableViewController: UIViewController {

    var noteList: [Note]?
    var data = [ TableSection: NoteSection ]()
    
    enum TableSection: Int, CaseIterable {
        case expired = 0, today, tomorrow, future
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: nil)
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = nil
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longPress)
        
        reloadData()
    }
    
    func reloadData() {
        self.noteList = FileNotebook.shared.notes
        setSectionsWithNotes()
    }
}

extension NoteTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = TableSection.allCases[section]
        guard let rows = data[tableSection] else {
            return 0
        }
        return rows.values.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let period = TableSection(rawValue: section) ?? TableSection.expired
        let date = Date.formatter.string(from: Date())
        switch period {
        case TableSection.expired:
            return "Expired"
        case TableSection.today:
            return "Today \(date)"
        case TableSection.tomorrow:
            return "Tomorrow"
        case TableSection.future:
            return "Future"
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == TableSection.expired.rawValue {
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = .red
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        if let tableSection = TableSection(rawValue: indexPath.section),
            let dataSection = data[tableSection] {
                let cellModel = dataSection.values[indexPath.row]
                cell.onBind(cellModel)

                return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("maldmaldw")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let tableSection = TableSection(rawValue: indexPath.section),
            let dataSection = data[tableSection] else {
                return
        }
        let dataCell = dataSection.values[indexPath.row]
        // TODO: rename NoteViewController to CellViewController
        let noteViewController = NoteViewController()
        noteViewController.data = dataCell
        
        navigationController?.pushViewController(noteViewController, animated: true)
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
            guard let tableSection = TableSection(rawValue: indexPath.section),
                let dataSection = self.data[tableSection] else {
                    return
            }
            let note = dataSection.values[indexPath.row]
            
            self.noteList = self.noteList!.filter({ $0.uid != note.uid })

            let deleteOp = RemoveNote(note: note, from: FileNotebook.shared)
            deleteOp.main()
            
            self.data[tableSection]?.removeItem(note)
            
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
                guard let sourceTableSection = TableSection(rawValue: sourceIndexPath.section),
                    let dataSection = data[sourceTableSection] else {
                        return
                }
                let sourceNote = dataSection.values[sourceIndexPath.row]

                guard let tableSection = TableSection(rawValue: indexPath.section) else {
                    return
                }
                let date : Date = {
                    switch tableSection {
                    case .expired:
                        return Date.expired
                    case .today:
                        return Date.today
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
                self.data[sourceTableSection]?.removeItem(sourceNote)
                let remove = RemoveNote(note: sourceNote, from: FileNotebook.shared)
                remove.main()
                self.data[tableSection]?.insertItem(note: note, index: indexPath.row)
                let save = SaveNotes(note: note, to: FileNotebook.shared)
                save.main()
                
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
            cell.reloadInputViews()
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

    func setSectionsWithNotes() {
        let noteList = self.noteList!
        
        for period in TableSection.allCases {
            let sectionIndex = period.rawValue
            switch sectionIndex {
            case 0:
                let notesInSection = noteList.filter({
                    Date.formatter.string(from: $0.expirationDate) < Date.formatter.string(from: Date.today )
                })
                data[period] = NoteSection(notes: notesInSection, index: sectionIndex)
                break
            case 1:
                let notesInSection = noteList.filter({
                    Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date.today )
                })
                data[period] = NoteSection(notes: notesInSection, index: sectionIndex)
                break
            case 2:
                let notesInSection = noteList.filter({
                    Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date.tomorrow )
                })
                data[period] = NoteSection(notes: notesInSection, index: sectionIndex)
                break
            case 3:
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
