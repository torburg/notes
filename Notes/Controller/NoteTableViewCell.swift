//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Maksim Torburg on 14/08/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var importance: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var reminder: UIImageView!
    
    static let reuseIdentifier = "NoteCell"
//    var note: Note?
    
    func onBind(_ note: Note) {
        content.text = note.content

        if note.expirationDate < Date.today {
            self.content.textColor = .red
        } else {
            content.textColor = .black
        }
        importance.layer.cornerRadius = importance.frame.width / 2
        switch note.importance {
            case .important:
                importance.backgroundColor = .red
            case .unimportant:
                importance.backgroundColor = .green
            case .regular:
                importance.backgroundColor = .gray
        }
       
        switch note.category {
            case .personal:
                category.text = Category.personal.rawValue
            case .work:
                category.text = Category.work.rawValue
            case .family:
                category.text = Category.family.rawValue
        }
        if note.reminder {
            reminder.image = UIImage(named: "active_reminder")
        } else {
            reminder.image = UIImage(named: "unactive_reminder")
        }
        
        reminder.image?.withRenderingMode(.alwaysTemplate)
        reminder.tintColor = .gray
    }

    override func awakeFromNib() {

        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
