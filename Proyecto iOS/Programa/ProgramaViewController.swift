//
//  ProgramaViewController.swift
//  Programa
//
//  Created by Román Sánchez on 23/08/18.
//  Copyright © 2018 romansg. All rights reserved.
//

import UIKit

class ProgramaViewController: UITableViewController {
    let actividades = [
        [
            "titulo": "Language Learning and the Brain",
            "ponente": "Dra. Marion Grein",
            "fecha": "2018-08-01",
            "hora": "10:00 - 11:00",
            "lugar": "Auditorio Alfonso Caso, Torre II de Humanidades",
            "tipo": "Plenaria"
        ],
        [
            "titulo": "Mindless Reading",
            "ponente": "Mtra. Estela López",
            "fecha": "2018-08-01",
            "hora": "12:00 - 13:00",
            "lugar": "Salón 201-A",
            "tipo": "Ponencia"
        ],
        [
            "titulo": "Translation and Interpreting",
            "ponente": "Mtro. Pedro Pineda",
            "fecha": "2018-08-01",
            "hora": "16:00 - 17:00",
            "lugar": "Salón 208-A",
            "tipo": "Taller"
        ],
        [
            "titulo": "Curriculum for Ninis",
            "ponente": "Dra. Carolina Juárez",
            "fecha": "2018-08-01",
            "hora": "18:00 - 18:30",
            "lugar": "Salón 203-B",
            "tipo": "Ponencia"
        ],
        [
            "titulo": "Formación de profesionistas de lengua",
            "ponente": "Dr. Carlos Ponce",
            "fecha": "2018-08-01",
            "hora": "14:00 - 15:00",
            "lugar": "Salón 201-B",
            "tipo": "Ponencia"
        ]
    ]
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var currentIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        revealViewController().rightViewRevealWidth = 200
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actividades.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaActividad", for: indexPath) as! ActividadViewCell
        let ponencia = actividades[indexPath.row]
        
        cell.labelTitulo.text = ponencia["titulo"]
        cell.labelPonente.text = ponencia["ponente"]
        cell.labelHora.text = ponencia["hora"]
        cell.labelLugar.text = ponencia["lugar"]
        cell.labelTipoPonencia.text = ponencia["tipo"]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    @IBAction func buttonEvaluacionTouch(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        currentIndexPath = tableView.indexPath(for: cell)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueActividad" {
            let controller = segue.destination as! ActividadViewController
            let index = self.tableView.indexPathForSelectedRow
            
            if let row = index?.row {
                controller.actividad = actividades[row]
            }
        } else if segue.identifier == "segueEvaluacion" && currentIndexPath != nil {
            let controller = segue.destination as! EvaluacionViewController
            let index = currentIndexPath
            
            if let row = index?.row {
                controller.actividad = actividades[row]
            }
        }
    }
}
