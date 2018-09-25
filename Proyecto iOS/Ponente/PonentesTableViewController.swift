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
    // Menú hamburguesa
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //Para definir las secciones de la tabla y los registros de cada seccion
    var registrosPorSeccion = [String: [Ponente]]()
    var titulosSecciones = [String]()
    
    var ponentes:[Ponente] = [] // Lista de ponentes
    var ponentesFiltrados:[Ponente] = [] //Para las busquedas

    //Para implementar refresh automático al hacer "swipe down"
    let refreshcontrol = UIRefreshControl()

    //Para implementar la búsqueda
    //Los resultados de la búsqueda se muestran aqui mismo, asi que se le pasa nil
    var searchController:UISearchController = UISearchController(searchResultsController: nil)

    /**
    * Filtra la lista de registros dependiendo la busqueda por nombre
    */
    func updateSearchResults(for searchController: UISearchController) {
        if let textoAbuscar = searchController.searchBar.text {
            ponentesFiltrados = ponentes.filter({ (r:Ponente) -> Bool in
                return ((r.nombre?.lowercased().contains(textoAbuscar.lowercased()))!)
            })
            
            //Volvemos a redefinir los titulos y valores de cada seccion
            //usando ahora los registros filtrados.
            definirSeccionesTabla()
        }
        
        self.tableView.reloadData() //Importante para que filtre la tabla
    }

    @objc func actualizaTabla() {
        self.ponentes = CoreDataManager.instance.allPonentes() //En viewDidAppear normalmente
        definirSeccionesTabla()

        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()    //Para que no quede cargando infinitamente
    }
    
    @objc func actualizaDatosServer() {
        //Aqui comienza la recarga, y automáticamente presenta un objeto UIActivityIndicator
        CoreDataManager.instance.cargaDatosPonentes() //CargaMasDatos del json al llamar a actualizaTabla
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        revealViewController().rightViewRevealWidth = 200
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        ////////////////////////////////////////////////////////////////////////
        ///////////////////////////Para las busquedas///////////////////////////
        ////////////////////////////////////////////////////////////////////////
        searchController.searchResultsUpdater = self
        self.tableView.tableHeaderView = searchController.searchBar
        
        //Para que cuando se hace la busqueda, permita seleccionar los resultados filtrados
        searchController.obscuresBackgroundDuringPresentation = false
        
        //En donde si se va a mostrar el searchController, solo aqui = true
        definesPresentationContext = true
        
        //Para que no capitalice la primera letra
        searchController.searchBar.autocapitalizationType = .none   //Enumeración
        
        //Para que no nos de sugerencias de autocorrección
        searchController.searchBar.autocorrectionType = .no //Enumeración
        
        ////////////////////////////////////////////////////////////////////////
        ///////////////////////////Para las busquedas///////////////////////////
        ////////////////////////////////////////////////////////////////////////
        
        ///////////////////////////CONFIGURACION Para el refresh del swipe down///////////////////////////
        //configurar que método invocar para refrescar datos
        refreshcontrol.addTarget(self, action: #selector(actualizaDatosServer), for: .valueChanged)
        
        //refreshControl es una property de UITableViewController
        self.refreshControl = refreshcontrol
        
        ///////////////////////////CARGA DE DATOS INICIAL///////////////////////////
        //Solo se carga la lista una sola vez, la siguientes veces sera hasta que el usuario recargue la lista
        //Si no hay datos en la BD, los trae del server
        self.ponentes = CoreDataManager.instance.allPonentes() //En viewDidAppear normalmente
        
        if ponentes.count <= 0 {
            print("Va a traer mas datos")
            //CoreDataManager.instance.cargaDatosPonentes() //CargaMasDatos del json al llamar a actualizaTabla
            //self.actualizaTabla()
            self.actualizaDatosServer()
        }
        
        //definirSeccionesTabla()
    }
    
    @objc func addTapped() {
        print("Se presiono el boton")
    }
    
    /**
     * Se recorren los registros, se verifica la primera letra del atributo nombre para
     * saber que secciones de la tabla se presentaran (Cada seccion es una letra del alfabeto)
     *
     * Se verifica la primera letra de cada nombre de los ponentes y se guardan los registros
     * en el arreglo de registrosPorSeccion
     */
    func definirSeccionesTabla() {
        registrosPorSeccion = [String: [Ponente]]()
        titulosSecciones = [String]()

        //to-Do
        //¿Verificar que ponentes no venga vacio?
        
        var registros:[Ponente] = []
        if !((searchController.searchBar.text?.isEmpty)!) {
            registros = ponentesFiltrados
        } else {
            registros = ponentes
        }

        for registro in registros {
            let letraInicial = String(registro.nombre!.prefix(1))
            if var valores = registrosPorSeccion[letraInicial] {
                valores.append(registro)
                registrosPorSeccion[letraInicial] = valores
            } else {
                registrosPorSeccion[letraInicial] = [registro]
            }
        }

        titulosSecciones = [String](registrosPorSeccion.keys)
        titulosSecciones = titulosSecciones.sorted(by: { $0 < $1 })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector:#selector(actualizaTabla), name:NSNotification.Name(rawValue: "kNuevosDatos"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * El numero de secciones lo maneja la variable titulosSecciones
     * la cual se establece en definirSeccionesTabla()
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return titulosSecciones.count
    }

    /**
     * El numero de registros por seccion lo maneja la variable registrosPorSeccion
     * la cual se establece en definirSeccionesTabla()
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let letra = titulosSecciones[section]

        //Si hay una bsqueda activa, tambien se busca en la variable registrosPorSeccion
        //Esta se actualiza al ir haciendo busquedas para decidir si busca en ponentes
        //o en ponentesFiltrados
        if let valoresPorSeccion = registrosPorSeccion[letra] {
            return valoresPorSeccion.count
        } else {
            return ponentes.count
        }
    }

    /**
     * La informacion de cada celda la obtenemos de la variable registrosPorSeccion
     * la cual se establece en definirSeccionesTabla()
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rCell", for: indexPath)

        // Configure the cell...
        let infoPonente:Ponente
        let letra = titulosSecciones[indexPath.section]
        
        //Si hay una bsqueda activa, tambien se busca en la variable registrosPorSeccion
        //Esta se actualiza al ir haciendo busquedas para decidir si busca en ponentes
        //o en ponentesFiltrados
        if let valoresPorSeccion = registrosPorSeccion[letra] {
            infoPonente = valoresPorSeccion[indexPath.row]
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

    /**
     * El titulo de cada seccion lo maneja la variable titulosSecciones
     * la cual se establece en definirSeccionesTabla()
     */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titulosSecciones[section]
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

        let letra = titulosSecciones[(indexPath?.section)!]
        
        //Si hay una bsqueda activa, tambien se busca en la variable registrosPorSeccion
        //Esta se actualiza al ir haciendo busquedas para decidir si busca en ponentes
        //o en ponentesFiltrados
        if let valoresPorSeccion = registrosPorSeccion[letra] {
             dvc.ponente = valoresPorSeccion[(indexPath?.row)!]
        } else {
            //Si por si acaso no encuentra alguno, devuelve el primero
            dvc.ponente = ponentes[(indexPath?.row) ?? 0]
        }
    }
    

}
