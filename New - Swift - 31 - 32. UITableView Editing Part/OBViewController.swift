//
//  OBViewController.swift
//  New - Swift - 31 - 32. UITableView Editing Part
//
//  Created by Oleksandr Bardashevskyi on 3/25/19.
//  Copyright © 2019 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

class OBViewController: UIViewController, UITableViewDataSource {
    
    var tableView = UITableView()
    var groupsArray = [OBGroup]()
    var groupCount = 0
    var count = 0
    
    let imageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "math")
        imv.contentMode = .scaleAspectFill
        return imv
    }()
    let titleImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "title")
        imv.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        imv.contentMode = .scaleAspectFit
        return imv
    }()
    
    override func loadView() {
        super.loadView()
        
        var frame = self.view.bounds
        frame.origin = CGPoint.zero
        let tableView = UITableView.init(frame: frame, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        tableView.backgroundView = imageView
        self.tableView = tableView
        
     
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //titleImageView.sizeToFit()
        
        self.navigationItem.titleView = titleImageView
        
        for i in 0..<4 {
            let group = OBGroup()
            group.name = "Group #\(i + 1)"
            for _ in 0..<3 {
                let student = OBStudent()
                group.students.append(student.randomStudent())
            }
            groupsArray.append(group)
        }
        groupCount = groupsArray.count
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(actionEdit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actiodAdd))
        
        self.tableView.allowsSelectionDuringEditing = true //разрешает действия при нажатии на ряд в режиме редактировани
        self.tableView.reloadData()
    }
    //MARK: - Actions
    @objc func actionEdit(sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        var item = UIBarButtonItem.SystemItem.edit
        if self.tableView.isEditing {
            item = UIBarButtonItem.SystemItem.done
        }
        for i in groupsArray {
            if i.students.isEmpty {
                
                count = groupsArray.firstIndex(of: i)!
                
                groupsArray.removeAll { $0 == i }
                
                let insertSections = IndexSet(arrayLiteral: count)
                
                self.tableView.beginUpdates()
                
                self.tableView.deleteSections(insertSections, with: .fade)
                
                self.tableView.endUpdates()
                
            }
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: item,
                                               target: self,
                                               action: #selector(actionEdit))
        //self.navigationItem.setRightBarButton(self.navigationItem.rightBarButtonItem, animated: true)
        if self.groupsArray.isEmpty {
            groupCount = 0
        }
    }
    @objc func actiodAdd(sender: UIBarButtonItem) {
        let group = OBGroup()
        groupCount += 1
        group.name = "Group #\(groupCount)"
       
        let newSection = 0
        
        self.groupsArray.insert(group, at: newSection)
        
        let insertSections = IndexSet(arrayLiteral: newSection)
        
        self.tableView.beginUpdates()
        
        self.tableView.insertSections(insertSections, with: arc4random().isMultiple(of: 2) ? UITableView.RowAnimation.left : UITableView.RowAnimation.right)
        
        self.tableView.endUpdates()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupsArray.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.groupsArray[section].name
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupsArray[section].students.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let addStudentIdentifier = "AddStudentCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: addStudentIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: addStudentIdentifier)
                cell?.textLabel?.textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                cell?.textLabel?.text = "Tap to add new student"
                cell?.textLabel?.font = UIFont(name: "Futura", size: 25)
                cell?.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 0.85)
            }
            return cell!
        } else {
            
            let studentIdentifier = "StudentCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: studentIdentifier)
            
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: studentIdentifier)
            }
            
            let group = self.groupsArray[indexPath.section]
            let student = group.students[indexPath.row - 1]
            
            cell?.textLabel?.text = "\(student.lastName) \(student.firstName)"
            cell?.detailTextLabel?.text = stringFromNumberFormatter(number: student.averageGrade)
            cell?.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 0.85)
            if student.averageGrade >= 4 {
                cell?.detailTextLabel?.textColor = .green
            } else if student.averageGrade >= 3 {
                cell?.detailTextLabel?.textColor = .yellow
            } else if student.averageGrade < 3 {
                cell?.detailTextLabel?.textColor = .red
            }
            
            return cell!
        }
    }
    //MARK: moveRows
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceGroup = self.groupsArray[sourceIndexPath.section]
        let student = sourceGroup.students[sourceIndexPath.row - 1]
        var tempArray = sourceGroup.students
        
        if sourceIndexPath.section == destinationIndexPath.section {
            tempArray.swapAt(sourceIndexPath.row - 1, destinationIndexPath.row - 1)
            sourceGroup.students = tempArray
        } else {
            tempArray.remove(at: sourceIndexPath.row - 1)
            sourceGroup.students = tempArray
            
            let destinationGroup = self.groupsArray[destinationIndexPath.section]
            tempArray = destinationGroup.students
            tempArray.insert(student, at: destinationIndexPath.row - 1)
            destinationGroup.students = tempArray
        }
        
        
    }
    //MARK: Actions with Delete Button.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let sourceGroup = self.groupsArray[indexPath.section]
            var tempArray = sourceGroup.students
            
            tempArray.remove(at: indexPath.row - 1)
            sourceGroup.students = tempArray
            
            self.tableView.beginUpdates()
            
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            self.tableView.endUpdates()
        }
    }
    
    //MARK: - stringFromNumberFormatter
    func stringFromNumberFormatter(number: Float) -> String {
        
        let nf = NumberFormatter()
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.maximumFractionDigits = 2
        
        return nf.string(for: number)!
    }
    

}
//MARK: - UITableViewDelegate
extension OBViewController: UITableViewDelegate {
    //MARK: - Change forn of header
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 30)!
        header.textLabel?.textColor = UIColor.black
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.row == 0 ? .none : .delete
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    //MARK: - Задаем какие ряды можно двигать
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    //MARK: - Add Student
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
            let alertController = UIAlertController(title: "Add new student:", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (alert) in
                let text = alertController.textFields?.first?.text?.components(separatedBy: " ")
                let group = self.groupsArray[indexPath.section]
                var tempArray = group.students
                
                let newStudent = OBStudent()
                guard let guardText = text else {
                    return
                }
                if guardText.count > 2 {
                    newStudent.firstName = guardText[1]
                    newStudent.lastName = guardText[0]
                    newStudent.averageGrade = Float(guardText[2])!
                } else {
                    newStudent.firstName = "ERROR"
                }
                
                let newStudentIndex = 0
                
                tempArray.insert(newStudent, at: newStudentIndex)
                group.students = tempArray
                
                let newIndexPath = IndexPath(item: newStudentIndex + 1, section: indexPath.section)
                
                self.tableView.beginUpdates()
                
                self.tableView.insertRows(at: [newIndexPath], with: .bottom)
                
                self.tableView.endUpdates()
                
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Name Lastname Mark"
            }
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
           
            
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Удалить"
    }
}
