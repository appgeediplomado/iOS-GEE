//
//  ActividadViewController.swift
//  Programa
//
//  Created by Román Sánchez on 23/08/18.
//  Copyright © 2018 romansg. All rights reserved.
//

import UIKit

class ActividadViewController: UITableViewController {
    var trabajo: Trabajo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 5
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        // Configure the cell...
        
        if indexPath.section == 0 { // Datos
            cell = tableView.dequeueReusableCell(withIdentifier: "celdaDatos", for: indexPath)
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = self.trabajo?.titulo
                
            case 1:
                if let fecha = self.trabajo?.fecha {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE d 'de' MMMM 'de' yyyy"
                    cell.textLabel?.text = dateFormatter.string(from: fecha)
                    
//                    dateFormatter.dateFormat = "yyyy-MM-dd"
//                    dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale
                    
//                    if let date = dateFormatter.date(from: fecha) {
//                        dateFormatter.dateFormat = "EEEE d 'de' MMMM 'de' yyyy"
//                        cell.textLabel?.text = dateFormatter.string(from: date)
//                    }
                }

                cell.imageView?.image = UIImage(named: "ios-calendar")
                
            case 2:
                cell.textLabel?.text = self.trabajo?.hora
                cell.imageView?.image = UIImage(named: "ios-reloj")

            case 3:
                cell.textLabel?.text = self.trabajo?.lugar
                cell.imageView?.image = UIImage(named: "ios-ubicacion")
                
            case 4:
                cell.textLabel?.text = "Evaluación"
                cell.imageView?.image = UIImage(named: "ios-evaluar")
                cell.accessoryType = .disclosureIndicator
                
            default:
                cell.textLabel?.text = ""
            }
            
            if cell.imageView?.image != nil {
                let itemSize = CGSize(width: 16, height: 16)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                let imageRect = CGRect(origin: CGPoint.zero, size: itemSize)
                cell.imageView?.image!.draw(in: imageRect)
                cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                UIGraphicsEndImageContext();
            }
        } else if indexPath.section == 1 { // Ponentes
            cell = tableView.dequeueReusableCell(withIdentifier: "celdaPonente", for: indexPath)
            let celdaPonente = cell as! PonenteViewCell
            celdaPonente.labelNombre.text = trabajo?.nombrePonente
        } else { // Abstract
            cell = tableView.dequeueReusableCell(withIdentifier: "celdaAbstract", for: indexPath)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45
        } else if indexPath.section == 1 {
            return 45
        } else if indexPath.section == 2 {
            return 350
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return trabajo?.modalidad
        } else if section == 1 {
            return "Ponente"
        } else {
            return "Abstract"
        }
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

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segueEvaluacion" {
            return tableView.indexPathForSelectedRow?.row == 4
        }
        
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEvaluacion" {
            let controller = segue.destination as! EvaluacionViewController
            controller.trabajo = trabajo
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
