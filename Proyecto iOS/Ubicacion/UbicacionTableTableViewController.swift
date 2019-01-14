//
//  UbicacionTableTableViewController.swift
//  Proyecto iOS
//
//  Created by Luis Vázquez on 8/27/18.
//  Copyright © 2018 App Gee. All rights reserved.
//

import UIKit

class UbicacionTableTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    let seccionEdificioA = ["Planta baja", "Primer piso", "Tercer piso"]
    let seccionEdificioB = ["Basamento", "Planta baja", "Primer piso"]
    
    let imgSeccionEdificioA = ["edificio_a_planta_baja", "edificio_a_primer_piso", "edificio_a_tercer_piso"]
    let imgSeccionEdificioB = ["edificio_b_basamento",  "edificio_b_planta_baja", "edificio_b_primer_piso"]
   
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaUbicacion", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.seccionEdificioA[indexPath.row]
        }else{
            cell.textLabel?.text = self.seccionEdificioB[indexPath.row]
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "ENALLT - Edificio A"
        } else  {
            return "ENALLT - Edificio B"
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let mapaLugar = segue.destination as! MapaLugarViewController
        let indexPath = self.tableView.indexPathForSelectedRow
        
        
        if indexPath?.section == 0 {
            mapaLugar.imagen = imgSeccionEdificioA[(indexPath?.row)!]
        } else {
            mapaLugar.imagen = imgSeccionEdificioB[(indexPath?.row)!]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueMapa", sender: self)
    }

}
