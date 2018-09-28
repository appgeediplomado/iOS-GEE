//
//  EvaluacionViewController.swift
//  Programa
//
//  Created by Román Sánchez on 24/08/18.
//  Copyright © 2018 romansg. All rights reserved.
//

import UIKit

class EvaluacionViewController: UIViewController {
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var starsCalidadPonencia: CosmosView!
    @IBOutlet weak var starsExperienciaPonente: CosmosView!
    @IBOutlet weak var starsRelevanciaPonencia: CosmosView!
    
    var trabajo: Trabajo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelTitulo.text = trabajo?.titulo
        
        if let retroalimentacion = CoreDataManager.instance.buscaRetroalimentacion(trabajoId: trabajo?.id ?? 0) {
            starsCalidadPonencia.rating = Double(retroalimentacion.ponencia)
            starsExperienciaPonente.rating = Double(retroalimentacion.ponente)
            starsRelevanciaPonencia.rating = Double(retroalimentacion.relevancia)
        } else {
            NotificationCenter.default.addObserver(
                self, selector: #selector(retroalimentacionAsignada),
                name: NSNotification.Name(rawValue: Constants.DATA_RETROALIMENTACION), object: nil)
        }
    }
    
    @IBAction func botonCalificarTouch(_ sender: Any) {
        if (!UserDefaults.standard.sesionIniciada()) {
            error(texto: "Para calificar una actividad debes iniciar sesión")
            return
        }
        
        if (starsCalidadPonencia.rating == 0.0 || starsExperienciaPonente.rating == 0.0 || starsRelevanciaPonencia.rating == 0.0) {
            error(texto: "Debes calificar todos los rubros")
            return
        }
        
        if (CoreDataManager.instance.existeRetroalimentacion(trabajoId: trabajo?.id ?? 0)) {
            error(texto: "Usted ya ha dado retroalimentacón a esta ponencia")
            return
        }
        
        let asistenteId = Int16(UserDefaults.standard.getUsuarioID());
        if let trabajoId = trabajo?.id {
            let evaluacion = Evaluacion(
                ponencia: Int16(starsCalidadPonencia.rating),
                ponente: Int16(starsExperienciaPonente.rating),
                relevancia: Int16(starsRelevanciaPonencia.rating))
            
            ServerDataManager.instance.evaluarTrabajo(asistenteId: asistenteId, trabajoId: trabajoId, evaluacion: evaluacion)
        }
       
        
    }
    
    @objc func retroalimentacionAsignada() {
        aviso(texto: "¡Muchas gracias por su retroalimentación!")
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
