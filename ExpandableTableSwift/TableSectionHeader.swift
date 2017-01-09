//
//  TableSectionHeader.swift
//  ExpandableTableSwift
//
//  Created by Tu (Tony) A. TRAN on 1/9/17.
//  Copyright © 2017 Tu (Tony) A. TRAN. All rights reserved.
//

import UIKit

protocol TableSectionHeaderDelegate {
    func sectionHeaderDidTapAt(sectionNumber: Int, isExpanding:Bool)
}

class TableSectionHeader: UITableViewHeaderFooterView {
    var sectionNumber: Int = 0
    var delegate: TableSectionHeaderDelegate?
    var isExpanding = false
    var isExpandAble = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBAction func sectionViewDidTap(_ sender: Any) {
        if (delegate != nil) {
            delegate?.sectionHeaderDidTapAt(sectionNumber: self.sectionNumber, isExpanding: isExpanding)
            
            if isExpandAble {
                 isExpanding = !isExpanding
            }
        }
    }
}

