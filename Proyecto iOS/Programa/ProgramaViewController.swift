//
//  ProgramaViewController.swift
//  Programa
//
//  Created by Román Sánchez on 23/08/18.
//  Copyright © 2018 romansg. All rights reserved.
//

import UIKit

// Tomado de
//  https://stackoverflow.com/questions/14718850/uirefreshcontrol-beginrefreshing-not-working-when-uitableviewcontroller-is-ins#answer-14719658
// para comenzar manualmente la actualización
extension UIRefreshControl {
    func programaticallyBeginRefreshing(in tableView: UITableView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
}

class ProgramaViewController: UITableViewController {
    var actividades: [Trabajo] = []
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var currentIndexPath: IndexPath?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        revealViewController().rightViewRevealWidth = 200
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        prepareRefreshControl()
        
        // Cargar datos locales en caso de haberlos
        actividades = CoreDataManager.instance.allTrabajos()
        
        // Si no hay datos locales al comienzo, mandar traer desde el servidor
        if actividades.count == 0 {
            self.refreshControl?.programaticallyBeginRefreshing(in: self.tableView)
            self.refreshData();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self, selector: #selector(nuevosDatos),
            name: NSNotification.Name(rawValue: Constants.DATA_NUEVOS_TRABAJOS), object: nil)
    }

    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actividades.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaActividad", for: indexPath) as! ActividadViewCell
        let trabajo = actividades[indexPath.row]
        
        cell.viewController = self
        cell.labelTitulo.text = trabajo.titulo
        cell.labelPonente.text = trabajo.nombrePonente
        cell.labelHora.text = trabajo.hora
        cell.labelLugar.text = trabajo.lugar
        cell.labelTipoPonencia.text = trabajo.modalidad

        if let fecha = trabajo.fecha {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE d 'de' MMMM 'de' yyyy"
            cell.lblFecha?.text = dateFormatter.string(from: fecha)

        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let fecha = trabajo.fecha {
            let fechaStr = dateFormatter.string(from: fecha)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let hora = trabajo.hora {
                cell.fechaActividad = dateFormatter.date(from: fechaStr + " " + hora)
            }
            
        }

        return cell
    }

    @IBAction func buttonEvaluacionTouch(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        currentIndexPath = tableView.indexPath(for: cell)
    }
    
    // MARK: - Refresh
    
    func prepareRefreshControl() {
        // Crea y asigna el control
        self.refreshControl = UIRefreshControl()
        
        // Indica al RefreshControl cuál metodo ejecutar cuando se invoque (con el "swipe down")
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
//        CoreDataManager.instance.cargaTrabajos()
        ServerDataManager.instance.cargaTrabajos()
    }
    
    @objc func nuevosDatos() {
        actividades = CoreDataManager.instance.allTrabajos()
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueActividad" {
            let controller = segue.destination as! ActividadViewController
            let index = self.tableView.indexPathForSelectedRow
            
            if let row = index?.row {
                 controller.trabajo = actividades[row]
            }
        } else if segue.identifier == "segueEvaluacion" && currentIndexPath != nil {
            let controller = segue.destination as! EvaluacionViewController
            let index = currentIndexPath
            
            if let row = index?.row {
                 controller.trabajo = actividades[row]
            }
        }
    }
}
