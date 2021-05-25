//
//  TableViewController.swift
//  YUAS
//
//  Created by Hakan Tunç on 14.01.2021.
//

import UIKit

class TableViewController: UITableViewController{

    @IBOutlet var myTableVİew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableVİew.delegate = self
        myTableVİew.dataSource = self


    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (StudentsData.StudentsNamesandSurnamesText == "Hakan Tunç"){
            return GlobalVariables.courseArrayForStudent1.count
        }
        if (StudentsData.StudentsNamesandSurnamesText == "Bahadır Bağ"){
            return GlobalVariables.courseArrayForStudent2.count
        }
        if (StudentsData.StudentsNamesandSurnamesText == "Özgür Eker"){
            return GlobalVariables.courseArrayForStudent3.count
        }
        if (StudentsData.StudentsNamesandSurnamesText == "admin"){
            return GlobalVariables.courseArrayForTeacher.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        if (StudentsData.StudentsNamesandSurnamesText == "Hakan Tunç"){
            cell.textLabel!.text = GlobalVariables.courseArrayForStudent1[indexPath.row]
            return cell
        }
        if (StudentsData.StudentsNamesandSurnamesText == "Bahadır Bağ"){
            cell.textLabel!.text = GlobalVariables.courseArrayForStudent2[indexPath.row]
            return cell
        }
        if (StudentsData.StudentsNamesandSurnamesText == "Özgür Eker"){
            cell.textLabel!.text = GlobalVariables.courseArrayForStudent3[indexPath.row]
            return cell
        }
        if (StudentsData.StudentsNamesandSurnamesText == "admin"){
            cell.textLabel!.text = GlobalVariables.courseArrayForTeacher[indexPath.row]
            return cell
        }
        return cell
    }
    
    

    
}
