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
    }
    
    @IBAction func botonCalificarTouch(_ sender: Any) {
        if (!UserDefaults.standard.sesionIniciada()) {
//            Alert.error(controller: self, mensaje: "Para calificar una actividad debe iniciar sesión")
            error(texto: "Para calificar una actividad debes iniciar sesión")
            return
        }
        
        if (starsCalidadPonencia.rating == 0.0 || starsExperienciaPonente.rating == 0.0 || starsRelevanciaPonencia.rating == 0.0) {
            error(texto: "Debes calificar todos los rubros")
            return
        }
        
        let asistenteId = UserDefaults.standard.getUsuarioID();
        
        
        let calidadPonencia = starsCalidadPonencia.rating
        print(calidadPonencia)
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
