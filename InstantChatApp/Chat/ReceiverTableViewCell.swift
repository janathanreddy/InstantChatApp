//
//  ReceiverTableViewCell.swift
//  InstantChatApp
//
//  Created by Admin Macappstudio on 25/05/21.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {

    @IBOutlet weak var ReceiverView: UIView!
    @IBOutlet weak var ReceTime: UILabel!
    @IBOutlet weak var ReceiverText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
