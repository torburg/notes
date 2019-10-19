//
//  StartViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 06/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var noteList: [Note] = []
    let reuseIdentifier = "noteCell"
    
    enum When: String, CaseIterable {
        case today = "Today"
        case tomorrow = "Tomorrow"
        case future = "Future"
        
        static var allValues: [When] {
            return [
                .today,
                .tomorrow,
                .future
            ]
        }
    }

    var sections: [ When: [Note] ] = [
        When.today: [],
        When.tomorrow: [],
        When.future: []
    ]
    
    fileprivate var sourceIndexPath: IndexPath?
    fileprivate var snapshot: UIView?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: nil)
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.tableView.tableFooterView = nil
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longPress)
        
        reloadData()
    }
    
    func reloadData() {
        //TODO
        print("reload date")

        let loadOperation = LoadNotes.init(notebook: FileNotebook.shared)
        guard let notes = loadOperation.result else {
            self.noteList = FileNotebook.generateNotebook()
            setNotesBySection()
            return
        }
        
        self.noteList = notes
        setNotesBySection()
    }
}

extension StartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNotesbySection(section).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = When.allValues[section]
        if date == .today {
            return "\(When.today.rawValue) \(Date.formatter.string(from: Date() ))"
        } else {
            return date.rawValue
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        let note = getNotesbySection(indexPath.section)[indexPath.row]
        cell.onBind(note)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("maldmaldw")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let note = getNotesbySection(indexPath.section)[indexPath.row]
        let noteViewController = NoteViewController()
        noteViewController.note = note
        
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
            let note = self.getNotesbySection(indexPath.section)[indexPath.row]
            self.noteList = self.noteList.filter({ $0.uid != note.uid })
            self.setNotesBySection()
            self.tableView.deleteRows(at: [indexPath], with: .left)
            completion(true)
        }
        action.backgroundColor = .red
        
        return action
    }

    @objc func longPressGestureRecognized(_ longPress: UIGestureRecognizer) {
        let state = longPress.state
        let location = longPress.location(in: tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: location) else {
            cleanup()
            return
        }
        switch state {
        case .began:
            sourceIndexPath = indexPath
            guard let cell = self.tableView.cellForRow(at: indexPath) else {
                return
            }
            snapshot = self.getCustomSnapshotFromView(inputView: cell)
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
            guard  let snapshot = self.snapshot else {
                return
            }
            var center = snapshot.center
            center.y = location.y
            snapshot.center = center
            guard let sourceIndexPath = self.sourceIndexPath  else {
                return
            }
            if indexPath != sourceIndexPath {
                let notesBySection = getNotesbySection(indexPath.section)
                let note = notesBySection[indexPath.row]
                guard let indexTo = noteList.firstIndex(where: { $0.uid == note.uid }) else {
                    return
                }
                let sourceNotesBySection = getNotesbySection(sourceIndexPath.section)
                let sourceNote = sourceNotesBySection[sourceIndexPath.row]
                guard let indexFrom = noteList.firstIndex(where: { $0.uid == sourceNote.uid }) else {
                    return
                }
                noteList.swapAt(indexFrom, indexTo)
                
                self.tableView.moveRow(at: sourceIndexPath, to: indexPath)
                self.sourceIndexPath = indexPath
//                updateSections(sourceIndexPath, indexPath)
//                reloadData()
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
        self.sourceIndexPath = nil
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
    
    //ToDo
    func updateSections(_ sourceIndexPath: IndexPath, _ indexPath: IndexPath) {
        let sourceSection = sourceIndexPath.first
        let sourceRow = sourceIndexPath.last
        
        let destSection = indexPath.first
        let destRow = indexPath.last

    }
    
    func getNotesbySection(_ section: Int) -> [Note] {
        guard let notesInSection = sections[ When.allValues[section] ] else {
            return []
        }
        return notesInSection
    }
    
    func setNotesBySection() {
        let noteList = self.noteList
        
        for section in sections {
            switch section.key {
            case .today:
                let noteInSection = noteList.filter({
                    Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date() )
                })
                self.sections[.today] = noteInSection
                break
            case .tomorrow:
                let noteInSection = noteList.filter({
                    Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date.tomorrow )
                })
                self.sections[.tomorrow] = noteInSection
                break
            case .future:
                let noteInSection = noteList.filter({
                    Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date.future )
                })
                self.sections[.future] = noteInSection
                break
            }
        }
    }
}


