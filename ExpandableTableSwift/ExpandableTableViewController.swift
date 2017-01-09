//
//  ExpandableTableViewController.swift
//  ExpandableTableSwift
//
//  Created by Tu (Tony) A. TRAN on 1/9/17.
//  Copyright © 2017 Tu (Tony) A. TRAN. All rights reserved.
//

import UIKit


class ExpandableTableViewController: UITableViewController {
    var cellDataSource = [ExpandableCell]()
    var sessionsAndRowDataSource = [[Int]]()
    var isExpenable: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        self.setupDataSource()
        self.setupSessionsAndRowDataSource()
        self.tableView.reloadData()
    }
    
    func setupDataSource()  {
        
        for index in 1...20 {
            let cell = ExpandableCell()
            cell.cellName = "This is cell No. \(index)"
            
            if index%1 == 0 {
                cell.isExpandAble = true
                
                for subIndex in 1...5 {
                    let subCell = ExpandableCell()
                    subCell.cellName = "This is SubCell No. \(subIndex) of cell No. \(index)"
                    
                    cell.subCellObject.append(subCell)
                }
            }
            
            cellDataSource.append(cell)
        }
        
        self.isExpenable = true
    }
    
    func setupSessionsAndRowDataSource() {
        sessionsAndRowDataSource.removeAll()
        
        for _ in cellDataSource {
            let rowArray = [Int]()
            
            sessionsAndRowDataSource.append(rowArray)
        }
    }

    func updateSessionsAndRowDataSource(atSection: Int, isExpanding: Bool)  {
        if isExpanding == true { //Then collapse
            sessionsAndRowDataSource.remove(at: atSection)
            let blankArray = [Int]()
            sessionsAndRowDataSource.insert(blankArray, at: atSection)
        }
        else { //Then expande
            var newRowArray = [Int]()
            let cellObject = cellDataSource[atSection]
            for _ in cellObject.subCellObject {
                newRowArray.append(1)
            }
            
            sessionsAndRowDataSource.remove(at: atSection)
            sessionsAndRowDataSource.insert(newRowArray, at: atSection)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadSections([atSection], with: .fade)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isExpenable == true {
            return sessionsAndRowDataSource.count
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isExpenable == true  {
            let headerData = cellDataSource[section]
            let checkData = sessionsAndRowDataSource[section]
            
            // Dequeue with the reuse identifier
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
            
            let header = cell as! TableSectionHeader
            header.delegate =  self
            
            header.sectionNumber = section
            header.titleLabel.text = headerData.cellName
            header.isExpandAble = headerData.subCellObject.count > 0
            header.isExpanding = checkData.count > 0

            return cell
            
        }
        else {
            return nil
        }

    }
  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpenable == true {
            let sessionDataSource = sessionsAndRowDataSource[section]
            return sessionDataSource.count
        }
        
       return sessionsAndRowDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData:ExpandableCell
        
        if isExpenable == true  {
            let sectionData =  cellDataSource[indexPath.section]
            let subObject = sectionData.subCellObject
            cellData = subObject[indexPath.row]
        }
        else {
            cellData = cellDataSource [indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath)
        cell.textLabel?.text = cellData.cellName
        cell.detailTextLabel?.text = cellData.cellName
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ExpandableTableViewController: TableSectionHeaderDelegate{
    func sectionHeaderDidTapAt(sectionNumber: Int, isExpanding:Bool){
        self.updateSessionsAndRowDataSource(atSection: sectionNumber, isExpanding: isExpanding)
    }
}
