//
//  PonentesTableViewController.swift
//  GeeApp
//
//  Created by Emmanuel García on 25/08/18.
//  Copyright © 2018 UNAM. All rights reserved.
//

import UIKit
import CoreData

class PonentesTableViewController: UITableViewController, UISearchResultsUpdating {

    var alfabetoDictionary = [String: [String]]()
    var seccionesTitles = [String]()
    var registros = [String]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    var ponentes:[Ponente] = []
    var ponentesFiltrados:[Ponente] = [] //Para las busquedas

    //Para implementar la búsqueda
    //Los resultados de la búsqueda se muestran aqui mismo, asi que se le pasa nil
    var searchController:UISearchController = UISearchController(searchResultsController: nil)

    func updateSearchResults(for searchController: UISearchController) {
        if let textoAbuscar = searchController.searchBar.text {
            ponentesFiltrados = ponentes.filter({ (r:Ponente) -> Bool in
                return ((r.nombre?.lowercased().contains(textoAbuscar.lowercased()))!)
            })
        }
        self.tableView.reloadData() //Importante para que filtre la tabla
    }

    @objc func actualizaTabla() {
        self.ponentes = CoreDataManager.instance.allPonentes() //En viewDidAppear normalmente
        print(ponentes)

        self.tableView.reloadData()
        
        //self.refreshControl?.endRefreshing()    //Para que no quede cargando infinitamente
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        revealViewController().rightViewRevealWidth = 200
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        probarAlfabeto()
        
    }
    
    @objc func addTapped() {
        print("Se presiono el boton")
    }
    
    func probarAlfabeto() {
        registros = ["Audi", "Aston Martin","BMW", "Bugatti", "Bentley","Chevrolet", "Cadillac","Dodge","Ferrari", "Ford","Honda","Jaguar","Lamborghini","Mercedes", "Mazda","Nissan","Porsche","Rolls Royce","Toyota","Volkswagen"]
        
        for registro in registros {
            let llave = String(registro.prefix(1))
            if var valores = alfabetoDictionary[llave] {
                valores.append(registro)
                alfabetoDictionary[llave] = valores
            } else {
                alfabetoDictionary[llave] = [registro]
            }
        }
        
        // 2
        seccionesTitles = [String](alfabetoDictionary.keys)
        seccionesTitles = seccionesTitles.sorted(by: { $0 < $1 })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //vA UNA U OTRA DE ESTAS LINEAS
        actualizaTabla()
        if ponentes.count <= 0 {
            print("Va a traer mas datos")
            CoreDataManager.instance.cargaDatosPonentes() //CargaMasDatos del json al llamar a actualizaTabla
        }

        NotificationCenter.default.addObserver(self, selector:#selector(actualizaTabla), name:NSNotification.Name(rawValue: "kNuevosDatos"), object: nil)

        //Recargar la tabla (sus datos) ya que esta capturado y actualizada la información
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return 1
        return seccionesTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //let llave = seccionesTitles[section]

        //Depende si hay una bsqueda activa
        if !((searchController.searchBar.text?.isEmpty)!) {
            return ponentesFiltrados.count
        }
        else /*if let valores = alfabetoDictionary[llave] */{
            //return valores.count
        }

        return ponentes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rCell", for: indexPath)

        // Configure the cell...
        //Dependiendo de si hay una búsqueda o no
        let infoPonente:Ponente

//        let llave = seccionesTitles[indexPath.section]
//        if let valores = alfabetoDictionary[llave] {
//            cell.textLabel?.text = valores[indexPath.row]
//        }
        
        
        //Depende si hay una bsqueda activa
        if !((searchController.searchBar.text?.isEmpty)!) {
            infoPonente = ponentesFiltrados[indexPath.row]
        } else {
            infoPonente = ponentes[indexPath.row]
        }
        
        cell.textLabel?.text = infoPonente.nombre

        let image = UIImage(named: "icons8-name_filled")
        cell.imageView?.image = image

        // REDIMENSIONAMOS LA IMAGEN AL TAMAÑO DESEADO
        let itemSize = CGSize(width:Constants.PONENTE_IMAGE_SIZE, height:Constants.PONENTE_IMAGE_SIZE)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect(origin: CGPoint.zero, size: itemSize)
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        ///////////////////////////////////////////////
        //Se cambia la propiedad Style del TableViewCell a Subtitle para que ponga el detalle
        if let _ = cell.detailTextLabel {
            if let descripcion = infoPonente.descripcion {
                cell.detailTextLabel?.text = "\(descripcion)"
            }
        }

        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return seccionesTitles[section]
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
            let dvc = segue.destination as! PonenteViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            //para que nos lleve al detalle correcto
            if !((searchController.searchBar.text?.isEmpty)!) {
                dvc.ponente = ponentesFiltrados[(indexPath?.row)!]
            } else {
                //Si por si acaso no encuentra alguno, devuelve el primero
                dvc.ponente = ponentes[(indexPath?.row) ?? 0]
            }
    }
    

}
