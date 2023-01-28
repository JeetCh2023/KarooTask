//
//  UserTableViewCell.swift
//  Karooo
//
//  Created by Jitender on 22/01/23.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    
    var employeeInfo:Employee? = nil {
        didSet{
           updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateUI(){
        profileName.text = employeeInfo?.name
        email.text = employeeInfo?.email
        mobileNumber.text = employeeInfo?.phone
    }
    
}
