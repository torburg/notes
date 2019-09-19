//
//  StartViewController.swift
//  Notes
//
//  Created by Maksim Torburg on 06/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    let noteList: [Note] = FileNotebook.generateNotebook()
    let reuseIdentifier = "noteCell"
    let sections: [String] = [
        "Today",
        "Tomorrow",
        "Future"
    ]
    
    @IBOutlet weak var tableView: UITableView!
//
//    @IBAction func showSecondView(_ sender: Any) {
//        let secondViewController = SecondViewController()
//        navigationController?.pushViewController(secondViewController, animated: true)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: nil)
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
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
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        //ToDo
        print(indexPath.section)
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
    
    func getNotesbySection(_ section: Int) -> [Note] {
        
        var noteInSection: [Note]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch sections[section] {
        case "Today":
            noteInSection = noteList.filter({
                dateFormatter.string(from: $0.expirationDate) == dateFormatter.string(from: Date() )
                
            })
        case "Tomorrow":
            noteInSection = noteList.filter({
                dateFormatter.string(from: $0.expirationDate) == dateFormatter.string(from: tomorrow() )
                
            })
        case "Future":
            noteInSection = noteList.filter({
                dateFormatter.string(from: $0.expirationDate) > dateFormatter.string(from: tomorrow() )
                
            })
        default:
            noteInSection = []
        }
        return noteInSection
    }
}


extension Date {
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
