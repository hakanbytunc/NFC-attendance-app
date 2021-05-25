//
//  TeacherViewController.swift
//  YUAS
//
//  Created by Hakan Tunç on 14.01.2021.
//

import UIKit

class TeacherViewController: UIViewController {
    

    @IBOutlet weak var dateLabelT: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,yyyy"
        let exactlyCurrentTime: Date = Date()
        dateLabelT.text = "\(dateFormatterPrint.string(from: exactlyCurrentTime))"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
