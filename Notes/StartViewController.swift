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
            print("\(indexPath)\n")
            print(noteList[indexPath.row].content)
            //TODO delete from DB (file), save to delete file and update UI
            self.noteList.remove(at: indexPath.row)
            
//            FileNotebook.shared.remove(with: noteList[indexPath.row].uid)
//            FileNotebook.shared.saveToFile()
            tableView.deleteRows(at: [indexPath], with: .left)
//            tableView.reloadData()
        }
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

