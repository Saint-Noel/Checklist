//
//  CheckListTableViewCell.swift
//  Checklist
//
//  Created by Yakeem Noel on 7/18/19.
//  Copyright © 2019 Yakeem Noel. All rights reserved.
//

import UIKit

class CheckListTableViewCell: UITableViewCell {


    @IBOutlet weak var checkmarkLabel: UILabel!
    @IBOutlet weak var todoTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
