//
//  centralProgressTableViewCell.swift
//  
//
//  Created by Rafi Rizwan on 2/19/16.
//
//

import UIKit
import Cartography

class centralProgressTableViewCell: UITableViewCell {

    @IBOutlet var progressconst: NSLayoutConstraint!
    
    var vname = String()
    var vnumber = String()
    
    var progconst: NSLayoutConstraint!
    let progress = UIView()
    
    var number: UILabel!
    var name: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        progress.backgroundColor = UIColor.redColor()
        progress.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(progress)
        
        name = UILabel()
        name.text = "Course Name"
        name.adjustsFontSizeToFitWidth = true
        name.textAlignment = NSTextAlignment.Left
        name.font = UIFont(name: "Avenir-Medium", size: 22)
        name.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(name)
        
        constrain(name, self) { (name, view) -> () in
            name.top == view.top + 20
            name.right == view.right
            name.left == view.left + 20
        }
        
        number = UILabel()
        number.text = "Course Number"
        name.adjustsFontSizeToFitWidth = true
        number.textAlignment = NSTextAlignment.Left
        number.font = UIFont(name: "Avenir", size: 18)
        number.textColor = UIColor.darkGrayColor()
        number.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(number)
        
        constrain(number, name) { (name, view) -> () in
            name.top == view.bottom + 20
            name.left == view.left
            name.right == view.right
        }

        
        constrain(progress, self) { bar, view in
            bar.top == view.top
            bar.left == view.left
            bar.height == view.height
            progconst = (bar.width == 0)
        }
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
