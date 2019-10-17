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
    let sections: [String] = [
        "Today",
        "Tomorrow",
        "Future"
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
        print("reload date")
    }
    
    func reloadData() {
        //TODO
        let loadOperation = LoadNotes.init(notebook: FileNotebook.shared)
        guard let notes = loadOperation.result else {
            self.noteList = FileNotebook.generateNotebook()
            return
        }
        
        self.noteList = notes
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
        if sections[section] == "Today" {
            return "\(sections[section]) \(Date.formatter.string(from: Date() ))"
        } else {
            return sections[section]
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = getNotesbySection(indexPath.section)[indexPath.row]
            self.noteList = noteList.filter({ $0.uid != note.uid })
            
            tableView.deleteRows(at: [indexPath], with: .left)
        }
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
//                let notesBySection = getNotesbySection(indexPath.section)
//                let note = notesBySection[indexPath.row]
//                
//                let sourceNotesBySection = getNotesbySection(sourceIndexPath.section)
//                let sourceNote = sourceNotesBySection[sourceIndexPath.row]
//                swap(&(noteList.first(where: { $0.uid == note.uid })), &(noteList.first(where: { $0.uid == sourceNote.uid
//                })))
                self.tableView.moveRow(at: sourceIndexPath, to: indexPath)
                self.sourceIndexPath = indexPath
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
    
    func getNotesbySection(_ section: Int) -> [Note] {
        
        var noteInSection: [Note]
        
        switch sections[section] {
        case "Today":
            noteInSection = noteList.filter({
                Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date() )
                
            })
        case "Tomorrow":
            noteInSection = noteList.filter({
                Date.formatter.string(from: $0.expirationDate) == Date.formatter.string(from: Date.tomorrow)
                
            })
        case "Future":
            print(Date.formatter.string(from: Date.tomorrow))
            noteInSection = noteList.filter({
                Date.formatter.string(from: $0.expirationDate) > Date.formatter.string(from: Date.tomorrow)
                
            })
        default:
            noteInSection = []
        }
        return noteInSection
    }
}

